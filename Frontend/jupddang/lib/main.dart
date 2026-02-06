import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome imports
import 'package:nes_ui/nes_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // import 추가
import 'features/auth/presentation/splash_screen.dart';

// RouteObserver를 글로벌로 선언하여 화면 간 이동 감지
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
        textTheme: const TextTheme().apply(fontFamily: 'NeoDunggeunmo'),
      ),
      // darkTheme: flutterNesTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
      navigatorObservers: [routeObserver], // RouteObserver 추가
      debugShowCheckedModeBanner: false,
    );
  }
}
