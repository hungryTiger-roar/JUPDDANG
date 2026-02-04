import 'package:flutter/material.dart';
import 'screens/account/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _successColor = Color(0xFF46A140);
  static const Color _successTint = Color(0x3346A140);
  static const Color _outerBorder = Color(0xFF532E16);
  static const Color _parchmentLight = Color(0xFFFAF3E0);
  static const Color _parchmentDark = Color(0xFF2D241E);

  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final ButtonStyle baseButtonStyle = ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(64, 52)),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
      shape: MaterialStateProperty.all(
        const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      elevation: MaterialStateProperty.all(0),
      side: MaterialStateProperty.all(
        const BorderSide(color: Colors.black, width: 4.0),
      ),
      padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((states) {
        if (states.contains(MaterialState.pressed)) {
          return const EdgeInsets.fromLTRB(28, 16, 20, 8); // Shifted
        }
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      }),
    );
    return ThemeData(
      fontFamily: 'Galmuri11',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6B4EFF),
        primary: _successColor,
        brightness: brightness,
        surface: isDark ? const Color(0xFF141414) : Colors.white,
      ),
      scaffoldBackgroundColor: isDark ? _parchmentDark : _parchmentLight,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? _parchmentDark : _parchmentLight,
        foregroundColor: isDark ? Colors.white : _outerBorder,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
        shape: const Border(
          bottom: BorderSide(color: Colors.black, width: 4.0),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFF532E16), width: 3.0),
        ),
        color: isDark ? const Color(0xFF3D322A) : Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF1DCE70),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black, width: 4.0),
        ),
        extendedTextStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: baseButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled))
              return const Color(0xFF1DCE70).withOpacity(0.5);
            return const Color(0xFF1DCE70);
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.all(Colors.white10),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: baseButtonStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF1F1F1F)),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(
            const BorderSide(color: Colors.black, width: 4.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: baseButtonStyle.copyWith(
          minimumSize: MaterialStateProperty.all(
            const Size(64, 44),
          ), // Text buttons can be slightly smaller
          foregroundColor: MaterialStateProperty.all(_successColor),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(
            _successColor.withOpacity(0.1),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: baseButtonStyle.copyWith(
          foregroundColor: MaterialStateProperty.all(_successColor),
          backgroundColor: MaterialStateProperty.all(_successTint),
          overlayColor: MaterialStateProperty.all(
            _successColor.withOpacity(0.1),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 4.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.black, width: 4.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFF1DCE70), width: 4.0),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        shape: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1DCE70) : Colors.black,
            width: 4.0,
          ),
        ),
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.black, width: 4.0),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
        contentTextStyle: const TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jupddang',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
