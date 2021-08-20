import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_downloader/ui/awesome_notificaton_download_page.dart';
import 'package:file_downloader/ui/list_download_page.dart';

import 'lib.dart';

///https://medium.com/@michallot/how-to-write-a-simple-downloading-app-with-flutter-2f55ae516867
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'key1',
      channelName: 'Proto Coders Point',
      channelDescription: "Notification example",
      defaultColor: Color(0XFF9050DD),
      ledColor: Colors.white,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    )
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Downloader',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      highContrastDarkTheme: ThemeData.dark(),
      highContrastTheme: ThemeData(brightness: Brightness.dark),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  void _routePage(BuildContext context, Widget route) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => route));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () =>
                    _routePage(context, LocalNotificationDownloadPage()),
                child: Text(
                  'Local Notificaton Download',
                )),
            ElevatedButton(
                onPressed: () =>
                    _routePage(context, AwesomeNotificatonDownloadPage()),
                child: Text(
                  'Awesome Notification Download',
                )),
            ElevatedButton(
                onPressed: () => _routePage(context, BaseListDownloadPage()),
                child: Text(
                  'List Download',
                )),
          ],
        ),
      ),
    );
  }
}
