import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_downloader/ui/download_page.dart';

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
      home: DownloadPage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Notify(); //localnotification method call below
//                 // when user top on notification this listener will work and user will be navigated to notification page
//                 AwesomeNotifications()
//                     .actionStream
//                     .listen((receivedNotifiction) {
//                   Navigator.push(
//                       context, MaterialPageRoute(builder: (_) => HomePage()));
//                 });
//               },
//               child: Text("Local Notification"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void Notify() async {
//   String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//         id: 1,
//         channelKey: 'key1',
//         title: 'This is Notification title',
//         body: 'This is Body of Noti',
//         bigPicture:
//             'https://protocoderspoint.com/wp-content/uploads/2021/05/Monitize-flutter-app-with-google-admob-min-741x486.png',
//         notificationLayout: NotificationLayout.ProgressBar),
//     schedule:
//         NotificationInterval(interval: 2, timeZone: timezom, repeats: true),
//     actionButtons: [
//       NotificationActionButton(label: 'Cancel', key: 'btnKey'),
//     ],
//   );
// }
