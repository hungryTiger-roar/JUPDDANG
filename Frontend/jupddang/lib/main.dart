import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome imports
import 'package:nes_ui/nes_ui.dart';
import 'features/auth/presentation/splash_screen.dart';

// RouteObserver를 글로벌로 선언하여 화면 간 이동 감지
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 가로 모드 방지 및 풀스크린 설정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 다시 활성화되거나 화면이 돌아올 때 몰입형 모드 재적용
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jupddang',
      theme: flutterNesTheme(brightness: Brightness.light).copyWith(
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'NeoDunggeunmo'),
          displayMedium: TextStyle(fontFamily: 'NeoDunggeunmo'),
          displaySmall: TextStyle(fontFamily: 'NeoDunggeunmo'),
          headlineLarge: TextStyle(fontFamily: 'NeoDunggeunmo'),
          headlineMedium: TextStyle(fontFamily: 'NeoDunggeunmo'),
          headlineSmall: TextStyle(fontFamily: 'NeoDunggeunmo'),
          titleLarge: TextStyle(fontFamily: 'NeoDunggeunmo'),
          titleMedium: TextStyle(fontFamily: 'NeoDunggeunmo'),
          titleSmall: TextStyle(fontFamily: 'NeoDunggeunmo'),
          bodyLarge: TextStyle(fontFamily: 'NeoDunggeunmo'),
          bodyMedium: TextStyle(fontFamily: 'NeoDunggeunmo'),
          bodySmall: TextStyle(fontFamily: 'NeoDunggeunmo'),
          labelLarge: TextStyle(fontFamily: 'NeoDunggeunmo'),
          labelMedium: TextStyle(fontFamily: 'NeoDunggeunmo'),
          labelSmall: TextStyle(fontFamily: 'NeoDunggeunmo'),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      // darkTheme: flutterNesTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
      navigatorObservers: [routeObserver], // RouteObserver 추가
      debugShowCheckedModeBanner: false,
    );
  }
}
