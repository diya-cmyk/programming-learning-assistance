import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/gamification_provider.dart';
import 'screens/home_screen.dart';
import 'theme/cyberpunk_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GamificationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programming Assistant',
      debugShowCheckedModeBanner: false,
      theme: CyberpunkTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
