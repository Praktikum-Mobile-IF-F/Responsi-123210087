import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsi_tpm/page/home_page.dart';
import 'package:responsi_tpm/page/login_page.dart';

import 'Model/login_model.dart';

String loginBox = 'loginBox';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<LoginModel>(LoginModelAdapter());
  await Hive.openBox<LoginModel>(loginBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Responsi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
