import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

class SmartChairApp extends StatelessWidget {
  const SmartChairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Chair',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}