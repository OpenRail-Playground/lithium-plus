import 'package:flutter/material.dart';

import 'flotte_dashboard/pages/flotte_page.dart';
import 'layout_page.dart';

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flotte Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: LayoutPage(
        selectedIndex: 0,
        onDestinationSelected: (index) {},
        child: const FlottePage(),
      ),
    );
  }
}
