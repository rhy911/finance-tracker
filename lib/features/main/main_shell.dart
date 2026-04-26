import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../statistic/statistics_screen.dart';
import '../settings/settings_screen.dart';
import '../history/manual_transaction_screen.dart';
import '../wallet/wallet_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    StatisticsScreen(),
    WalletScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home, 
                        size: 30, 
                        color: _selectedIndex == 0 ? const Color(0xFF438883) : Colors.grey
                      ), 
                      onPressed: () => _onItemTapped(0),
                    ),
                    IconButton(
                      icon: Icon(Icons.bar_chart, 
                        size: 30, 
                        color: _selectedIndex == 1 ? const Color(0xFF438883) : Colors.grey
                      ), 
                      onPressed: () => _onItemTapped(1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 80), // Wider space for FAB notch
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.account_balance_wallet_outlined, 
                        size: 30, 
                        color: _selectedIndex == 2 ? const Color(0xFF438883) : Colors.grey
                      ), 
                      onPressed: () => _onItemTapped(2),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_outlined, 
                        size: 30, 
                        color: _selectedIndex == 3 ? const Color(0xFF438883) : Colors.grey
                      ), 
                      onPressed: () => _onItemTapped(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => const ManualTransactionScreen()),
        ),
        backgroundColor: const Color(0xFF438883),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 34, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
