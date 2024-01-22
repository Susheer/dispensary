// landing_screen.dart
import 'package:dispensary/providers/landing_provider.dart';
import 'package:dispensary/screens/all_patients_screen.dart';
import 'package:dispensary/screens/dashboard_screen.dart';
import 'package:dispensary/screens/search_screen.dart';
import 'package:dispensary/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;

  // Define the screens you want to navigate to
  final List<Widget> _screens = [
    DashboardScreen(),
    SearchScreen(),
    AllPatientsScreen(),
    SettingsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<LandingScreenProvider>(
        builder: (context, landingProvider, child) {
      return Scaffold(
          appBar: AppBar(
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset('assets/images/logo.png', height: 40, width: 40),
                  const SizedBox(width: 10),
                  const Text(
                    'Sai Clinic',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  landingProvider.index = 1;
                },
              ),
              IconButton(
                icon: const Icon(Icons.account_balance_wallet),
                onPressed: () {
                  // Implement notification button functionality
                },
              ),
              Text("Index${landingProvider.index}")
            ],
          ),
          body: _screens[landingProvider.index],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              // actuall placement of screeens in screen List
              const int patientIndex = 2;
              const int settingsIndex = 3;
              const int dashboardIndex = 0;
              setState(() {
                debugPrint("Index $index");
                if (2 == index) {
                  landingProvider.index = settingsIndex;
                }
                if (1 == index) {
                  landingProvider.index = patientIndex;
                }
                if (0 == index) {
                  landingProvider.index = dashboardIndex;
                }
              });
            },
            showUnselectedLabels: true,
            fixedColor: Colors.black, // Set the color for the selected item
            unselectedItemColor:
                Colors.black, // Set the color for unselected items
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Patient List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ));
    });
  }
}
