import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'features/auth/presentation/splash_screen.dart';

// RouteObserver를 글로벌로 선언하여 화면 간 이동 감지
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jupddang',
      theme: flutterNesTheme(brightness: Brightness.light),
      darkTheme: flutterNesTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      navigatorObservers: [routeObserver], // RouteObserver 추가
      debugShowCheckedModeBanner: false,
    );
  }
}
