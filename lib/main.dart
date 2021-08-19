import 'lib.dart';

///https://medium.com/@michallot/how-to-write-a-simple-downloading-app-with-flutter-2f55ae516867
void main() {
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
      home: HomePage(),
    );
  }
}
