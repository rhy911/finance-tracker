import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/database/isar_database.dart';
import 'core/services/category_service.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/main/main_shell.dart';
import 'package:permission_handler/permission_handler.dart';

class NativeService {
  static const _channel = MethodChannel('com.example.finance_app/service');

  static Future<void> startService() async {
    try {
      await _channel.invokeMethod('startService');
    } catch (e) {
      debugPrint("NativeService: Start failed: $e");
    }
  }

  static Future<void> stopService() async {
    try {
      await _channel.invokeMethod('stopService');
    } catch (e) {
      debugPrint("NativeService: Stop failed: $e");
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database
  await IsarDatabase.init();
  
  // Add default categorization rules
  await CategoryService().addDefaultRules();
  
  // Start native background service
  await NativeService.startService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialCheck(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/dashboard': (context) => const MainShell(),
      },
    );
  }
}

class InitialCheck extends StatefulWidget {
  const InitialCheck({super.key});

  @override
  State<InitialCheck> createState() => _InitialCheckState();
}

class _InitialCheckState extends State<InitialCheck> {
  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    // Basic permissions check
    final status = await Permission.notification.status;
    
    if (mounted) {
      if (status.isGranted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
