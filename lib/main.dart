import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/widget/expense_tile.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF46AF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen()
    );
  }
}
