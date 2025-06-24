import 'package:flutter/material.dart';
import 'package:poc/app_router.dart';

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Flotte Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo),
      routerConfig: appRouter.config(),
    );
  }
}
