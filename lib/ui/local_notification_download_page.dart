import '../lib.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class LocalNotificationDownloadPage extends StatefulWidget {
  const LocalNotificationDownloadPage({Key? key}) : super(key: key);

  @override
  _LocalNotificationDownloadPageState createState() => _LocalNotificationDownloadPageState();
}

class _LocalNotificationDownloadPageState extends State<LocalNotificationDownloadPage> {
  final String _fileUrl =
      'https://techcrunch.com/wp-content/uploads/2015/04/codecode.jpg';
  final String _fileName = 'codecode.jpg';
  String _progress = '-';
  final Dio _dio = Dio();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//------------------------------------------------------------------------------
// for notification
//------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<void> _onSelectNotification(String? json) async {
    final obj = jsonDecode(json!);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj["error"]}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      priority: Priority.high,
      importance: Importance.max,
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
      0,
      isSuccess ? 'Success' : 'Failure',
      isSuccess
          ? 'File has been downloaded successfully.'
          : 'There was an error while downloading the file.',
      platform,
      payload: json,
    );
  }

//------------------------------------------------------------------------------
// for download
//------------------------------------------------------------------------------
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
      final response = await _dio.download(
        _fileUrl,
        savePath,
        onReceiveProgress: _onReceiveProgress,
      );

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + '%';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Download progress:',
            ),
            Text(
              '$_progress',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _download,
        tooltip: 'Download',
        child: Icon(Icons.file_download),
      ),
    );
  }
}
