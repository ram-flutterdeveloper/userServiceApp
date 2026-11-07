import 'package:flutter/material.dart';
import 'package:user_servicehub/app/service_hub_app.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServiceLocator.setup();
  runApp(const ServiceHubApp());
}
