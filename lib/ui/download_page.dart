import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final String _fileUrl =
      'https://techcrunch.com/wp-content/uploads/2015/04/codecode.jpg';
  final String _fileName = 'codecode.jpg';
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _requestNotification() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Awesome Notification'),
            content: Text('Need Permisson.'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await AwesomeNotifications()
                      .requestPermissionToSendNotifications();
                },
                child: Text('Request'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _createNotification(int received, int total) async {
    final progress = received / total * 100;
    if (progress < 100) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'key1',
          title: 'Simple Notification',
          body: progress == 100 ? 'finished' : 'downloading',
          notificationLayout: progress == 100
              ? NotificationLayout.Default
              : NotificationLayout.ProgressBar,
          locked: true,
        ),
        actionButtons: [
          NotificationActionButton(
            label: 'Cancel',
            key: 'btnKey',
            buttonType: ActionButtonType.Default,
          ),
        ],
      );
    }
    print((received / total * 100).toStringAsFixed(0) + '%');
  }

  Future<void> _onTapNotification() async {
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      print(receivedNotification.buttonKeyPressed);
    });
  }
  //-----------------------------------------------------------------------------
  // for download
  //-----------------------------------------------------------------------------

  Future<Directory> get _getDownloadDirectory async =>
      await getApplicationDocumentsDirectory();

  Future<bool> get _requestPermission async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission.isDenied) {
      Map<Permission, PermissionStatus> permissions =
          await [Permission.storage].request();
      if (permissions[Permission.storage] == PermissionStatus.granted)
        return true;
    } else {
      return true;
    }
    return false;
  }

  Future<void> _download() async {
    final dir = await _getDownloadDirectory;
    final isPermissionGranted = await _requestPermission;
    if (isPermissionGranted) {
      final savePath = path.join(dir.path, _fileName);
      await _startDownload(savePath);
    } else {
      // handle the scenario when user declines the permission
    }
  }

  Future<void> _startDownload(String? savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      // await _requestNotification();
      final response = await dio.download(
        _fileUrl,
        savePath,
        onReceiveProgress: _onReceiverProgress,
        // onReceiveProgress: _createNotification,
      );

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      // await AwesomeNotifications().dismissAllNotifications();
      await AwesomeNotifications().cancelAll();
    }
  }

  void _onReceiverProgress(int received, int total) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${(received / total * 100).toStringAsFixed(0)}%')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _download(),
        tooltip: 'Download',
        child: Icon(Icons.file_download),
      ),
    );
  }
}
