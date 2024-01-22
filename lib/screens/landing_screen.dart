// landing_screen.dart
import 'package:dispensary/screens/all_patients_screen.dart';
import 'package:dispensary/screens/dashboard_screen.dart';
import 'package:dispensary/screens/search_screen.dart';
import 'package:flutter/material.dart';

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
    AllPatientsScreen()
  ];
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_balance_wallet),
              onPressed: () {
                // Implement notification button functionality
              },
            ),
            Text("Index$_currentIndex")
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
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
              icon: Icon(Icons.search),
              label: 'Search',
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
  }
}
