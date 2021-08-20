import '../lib.dart';

class BaseListDownloadPage extends StatelessWidget {
  const BaseListDownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DownloaderController()),
        ChangeNotifierProvider(
          create: (_) => ProgressController(progressList: []),
        ),
      ],
      child: ListDownloadPage(),
    );
  }
}

class ListDownloadPage extends StatelessWidget {
  const ListDownloadPage({Key? key}) : super(key: key);

  List<ListModel> get _getList {
    final String url = 'https://www.ft.com/__origami/service/image/v2/images/raw/https%3A%2F%2Fd1e00ek4ebabms.cloudfront.net%2Fproduction%2Fe5d2ad35-c2cc-4b47-9e62-46097217107a.jpg?fit=scale-down&source=next&width=700';
    // final String url = 'https://picsum.photos/200';
    return List.generate(15,
        (index) => ListModel(url: url, finleName: 'picsum${index + 1}.jpg'));
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProgressController>().setList(_getList.length);
    return Scaffold(
      appBar: AppBar(),
      body: _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) => Container(
        margin: const EdgeInsets.all(4),
        child: ListView.builder(
          itemCount: _getList.length,
          itemBuilder: (context, index) => _listItem(
            context,
            index,
            _getList[index],
          ),
        ),
      );

  Widget _listItem(BuildContext context, int index, ListModel data) =>
      Consumer2<DownloaderController, ProgressController>(
        builder: (context, provider, progress, child) => Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${data.finleName}'),
              _progressWidget(context, data, progress, index),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () async => provider.download(
                  data,
                  onReceiveProgress: (int received, int total) async => progress
                      .setProgress((received / total * 100).round(), index),
                ),
                icon: Icon(
                  data.isSuccess! ? Icons.check : Icons.download,
                  size: 18,
                ),
                label: Text(data.isSuccess! ? 'Complete' : 'Download'),
              ),
            ],
          ),
        ),
      );

  Widget _progressWidget(
    BuildContext context,
    ListModel data,
    ProgressController progress,
    int index,
  ) =>
      Visibility(
        visible: data.dwlStatus == DwlStatus.DOWNLOADING,
        child: Expanded(
          child: Text(
            '${progress.progressList![index].toStringAsFixed(0)}%',
            textAlign: TextAlign.end,
          ),
        ),
      );
}

class ListModel {
  ListModel({
    this.url,
    this.finleName,
    this.path,
    this.isSuccess = false,
    this.error,
    this.progress = 0,
    this.dwlStatus = DwlStatus.NOT_START,
  });
  String? url;
  DwlStatus dwlStatus;
  String? finleName;
  String? path;
  bool? isSuccess;
  String? error;
  int? progress;
}

enum DwlStatus {
  NOT_START,
  DOWNLOADING,
  ERROR,
  COMPLETE,
}
