import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../main.dart'; // Import NativeService

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver {
  bool _hasListenerPermission = false;
  bool _hasNotificationPermission = false;
  bool _isBatteryOptimized = true;
  bool _step3Clicked = false;
  bool _step4Clicked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStatus();
    }
  }

  Future<void> _checkStatus() async {
    debugPrint("Onboarding: Checking status...");
    
    // Check Notification Listener Permission via platform channel
    bool hasListener = false;
    try {
      const channel = MethodChannel('com.example.finance_app/service');
      hasListener = await channel.invokeMethod('checkListenerPermission') ?? false;
    } catch (e) {
      debugPrint("Error checking listener permission: $e");
    }

    final notificationStatus = await Permission.notification.status;
    final isIgnored = await OptimizeBattery.isIgnoringBatteryOptimizations();
    
    if (mounted) {
      setState(() {
        _hasListenerPermission = hasListener;
        _hasNotificationPermission = notificationStatus.isGranted;
        _isBatteryOptimized = !isIgnored;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkStatus,
            tooltip: 'Refresh Status',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Follow these steps to enable 100% automated transaction tracking.',
                    ),
                    const SizedBox(height: 32),
                    _buildStep(
                      number: 1,
                      title: 'Notification Access (Listener)',
                      description: 'Find "Finance Tracker" in the list and toggle it ON. This allows reading bank alerts.',
                      isCompleted: _hasListenerPermission,
                      onTap: () async {
                        try {
                          const channel = MethodChannel('com.example.finance_app/service');
                          await channel.invokeMethod('openListenerSettings');
                        } catch (e) {
                          debugPrint("Error opening listener settings: $e");
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildStep(
                      number: 2,
                      title: 'Show Notifications (Poster)',
                      description: 'Allow the app to show your daily balance in the status bar.',
                      isCompleted: _hasNotificationPermission,
                      onTap: () async {
                        final status = await Permission.notification.request();
                        if (status.isPermanentlyDenied) {
                          await openAppSettings();
                        }
                        _checkStatus();
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildStep(
                      number: 3,
                      title: 'Enable Autostart (Xiaomi)',
                      description: 'Find "Finance Tracker" and toggle it ON. This lets the app wake up by itself.',
                      isCompleted: _step3Clicked,
                      onTap: () async {
                        setState(() => _step3Clicked = true);
                        try {
                          const channel = MethodChannel('com.example.finance_app/service');
                          await channel.invokeMethod('openAutostartSettings');
                        } catch (e) {
                          await openAppSettings();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildStep(
                      number: 4,
                      title: 'Pop-up Windows (Xiaomi)',
                      description: 'Enable "Display pop-up windows" AND "Open new windows while running in background".',
                      isCompleted: _step4Clicked,
                      onTap: () async {
                        setState(() => _step4Clicked = true);
                        try {
                          const channel = MethodChannel('com.example.finance_app/service');
                          await channel.invokeMethod('openOtherPermissionsSettings');
                        } catch (e) {
                          await openAppSettings();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildStep(
                      number: 5,
                      title: 'Battery Saver: No Restrictions',
                      description: 'Set Battery Saver to "No restrictions" to prevent the tracker from sleeping.',
                      isCompleted: !_isBatteryOptimized,
                      onTap: () async {
                        await OptimizeBattery.stopOptimizingBatteryUsage();
                        _checkStatus();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_hasListenerPermission && _hasNotificationPermission)
                    ? () async {
                        await NativeService.startService();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: (_hasListenerPermission && _hasNotificationPermission) ? Colors.blue : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int number,
    required String title,
    required String description,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCompleted ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isCompleted ? Colors.green.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isCompleted ? Colors.green : Colors.blue,
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text('$number', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
