import '../lib.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

class ProgressController with ChangeNotifier {
  ProgressController({this.progressList});
  List<int>? progressList;

  void setList(int length) {
    progressList!.clear();
    for (int i = 0; i < length; i++) {
      progressList!.add(0);
    }
  }

  void setProgress(int? progress, int? index) {
    if (this.progressList!.length < index!) return;
    this.progressList![index] = progress!;
    notifyListeners();
  }
}

class DownloaderController with ChangeNotifier {
  Dio _dio = Dio();

  Future<void> download(ListModel data,
      {@required ProgressCallback? onReceiveProgress}) async {
    final dir = await FileUtils.getDownloadDirectory;
    final isPermissionGranted = await FileUtils.requestPermission;
    if (isPermissionGranted) {
      final savePath = path.join(dir.path, data.finleName);
      data.dwlStatus = DwlStatus.DOWNLOADING;
      notifyListeners();
      await _startDownload(savePath, data, onReceiveProgress!);
    } else {
      // handle the scenario when user declines the permission
    }
  }

  Future<void> _startDownload(String? savePath, ListModel data,
      ProgressCallback onReceiveProgress) async {
    try {
      final response = await _dio.download(
        data.url!,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
      data.dwlStatus =
          response.statusCode == 200 ? DwlStatus.COMPLETE : DwlStatus.ERROR;
      data.isSuccess = response.statusCode == 200;
      data.path = savePath;
    } catch (ex) {
      data.error = ex.toString();
    } finally {
      notifyListeners();
    }
  }
}
