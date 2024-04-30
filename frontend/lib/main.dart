import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/theme/strings.dart';
import 'package:me_and_flora/me_and_flora_app.dart';

import 'core/domain/service/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  AppMetrica.activate(const AppMetricaConfig(appMetrica));
  runApp(const MeAndFloraApp());
}
