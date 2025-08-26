import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hacom_frontend_app/app.dart';
import 'package:hacom_frontend_app/core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await initDependencies();

  runApp(const MyApp());
}
