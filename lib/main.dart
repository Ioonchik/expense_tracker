import 'package:expense_tracker/app.dart';
import 'package:expense_tracker/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeService = ThemeService();
  final themeMode = await themeService.loadThemeMode();

  await Hive.initFlutter();
  runApp(MyApp(initialThemeMode: themeMode));
}