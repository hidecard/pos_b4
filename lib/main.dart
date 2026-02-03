import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './screens/main_screen.dart';
import './controllers/cart_controller.dart';
import './controllers/customer_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'POS App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => CartController());
        Get.lazyPut(() => CustomerController());
      }),
    );
  }
}
