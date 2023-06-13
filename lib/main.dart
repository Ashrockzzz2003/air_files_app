
import 'package:air_files/screens/login_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? isLoggedIn;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sp = await SharedPreferences.getInstance();
  isLoggedIn = sp.getBool("isLoggedIn") ?? false;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final _defaultLightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Air Files',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
        ),
        themeMode: ThemeMode.system,
        home:
        const LoginScreen(),
      );
    });
  }
}
