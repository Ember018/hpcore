import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/task_viewmodel.dart';
import 'views/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hpcore',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
      home: const Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
