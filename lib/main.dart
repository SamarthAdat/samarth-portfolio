import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/di/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const PortfolioApp());
}
