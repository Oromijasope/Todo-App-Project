import 'package:flutter/material.dart';
import 'package:todo_app_project/home_screen.dart';

ColorScheme kDarkColorScheme = ColorScheme.dark(
  primary: Color(0xFF121212),
);



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, colorScheme: kDarkColorScheme),
      debugShowCheckedModeBanner: false,
      title: "Todo App",
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(100, 255, 218, 1),
          foregroundColor: Colors.black,
        ),
      ),
      home: HomeScreen(),
      themeMode: ThemeMode.light,
    );
  }
}
