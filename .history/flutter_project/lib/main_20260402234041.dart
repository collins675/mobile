import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:get/get.dart';

import 'configs/routes.dart';

void main() {
  Get.put(SessionController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
