import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const CampusRescueApp(),
    ),
  );
}

class CampusRescueApp extends StatelessWidget {
  const CampusRescueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Rescue',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: Consumer<AppState>(
        builder: (_, state, __) => state.isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
