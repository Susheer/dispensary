// landing_screen.dart
import 'package:dispensary/appConfig.dart';
import 'package:dispensary/providers/landing_provider.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/screens/all_medicine_screen.dart';
import 'package:dispensary/screens/all_patients_screen.dart';
import 'package:dispensary/screens/dashboard_screen.dart';
import 'package:dispensary/screens/registration_screen.dart';
import 'package:dispensary/screens/search_screen.dart';
import 'package:dispensary/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // Define the screens you want to navigate to
  final List<Widget> _screens = [
    DashboardScreen(),
    SearchScreen(),
    AllPatientsScreen(),
    SettingsScreen(),
    RegistrationScreen(), // 4
    AllMedicineScreen() // 5
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<LandingScreenProvider>(builder: (context, landingProvider, child) {
      return Scaffold(
        appBar: AppBar(
          titleTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color(0xff6750a4),
          title: TitleWidget(),
          actions: [
            IconButton(
              tooltip: "Pharmecy Management",
              icon: const Icon(Icons.business_center, color: Colors.white),
              onPressed: () {
                landingProvider.index = 5;
                // Implement notification button functionality
              },
            ),
            IconButton(
              icon: const Icon(
                color: Colors.white,
                Icons.account_circle,
                size: 35,
              ),
              onPressed: () {
                landingProvider.index = 1;
              },
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        body: _screens[landingProvider.index],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            // actuall placement of screeens in screen List
            const int patientIndex = 2;
            const int settingsIndex = 3;
            const int searchIndex = 1;
            const int dashboardIndex = 0;
            const int registerIndex = 4;
            setState(() {
              debugPrint("Index $index");
              if (2 == index) {
                landingProvider.index = searchIndex;
              }
              if (1 == index) {
                landingProvider.index = registerIndex;
              }
              if (0 == index) {
                landingProvider.index = dashboardIndex;
              }
            });
          },
          fixedColor: Colors.black,
          unselectedItemColor: Colors.black,

          // Set the color for unselected items
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Patient',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search_sharp),
              label: 'Search Patient',
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff6750a4),
                ),
                child: Text(
                  'SAI CLINIC',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Delete database'),
                onTap: () {
                  Provider.of<LandingScreenProvider>(context, listen: false).deleteDatabaseAndClear();
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: const Text('Add Fake medicines'),
                onTap: () {
                  Provider.of<MedicineProvider>(context, listen: false).insertsDummyMedicines();
                  // landingScreenProvider.index = 3;
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: const Text('Clear Medicine Table'),
                onTap: () {
                  Provider.of<MedicineProvider>(context, listen: false).deleteAllMedicines();
                  // landingScreenProvider.index = 3;
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: const Text('Add Fake Patients'),
                onTap: () {
                  Provider.of<PatientProvider>(context, listen: false).registerDummyPatient();
                  // landingScreenProvider.index = 3;
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: const Text('Clear Patients'),
                onTap: () {
                  Provider.of<PatientProvider>(context, listen: false).deleteAllPatients();
                  // landingScreenProvider.index = 3;
                  Navigator.pop(context); // Close the drawer
                },
              ),
              // Add more ListTile widgets for additional fake buttons
            ],
          ),
        ),
      );
    });
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            AppConfig.nameOfClinic,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
// testing
// testi g2