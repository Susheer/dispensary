// landing_screen.dart
import 'package:dispensary/appConfig.dart';
import 'package:dispensary/common/user_greet.dart';
import 'package:dispensary/common/user_profile_widget.dart';
import 'package:dispensary/providers/auth_provider.dart';
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
import 'package:google_sign_in/google_sign_in.dart';
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
          title: Container(
            child: Row(
              children: [
                Text(
                  AppConfig.nameOfClinic,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              tooltip: "Pharmecy Management",
              icon: const Icon(Icons.business_center, color: Colors.white),
              onPressed: () {
                landingProvider.index = 5;
                // Implement notification button functionality
              },
            ),
            const UserProfileWidget(),
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
          width: MediaQuery.of(context).size.width * 70 / 100,
          child: Column(
            children: [
              DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xff6750a4)),
                  child: Container(
                      constraints: const BoxConstraints.expand(), child: const UserName())),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.view_headline_outlined),
                      title: const Text('Reset App'),
                      subtitle: const Text("clear app data"),
                      onTap: () {
                        Provider.of<LandingScreenProvider>(context, listen: false)
                            .deleteDatabaseAndClear();
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.post_add_outlined),
                      title: const Text('Add Medecine'),
                      subtitle: const Text("fake drugs"),
                      onTap: () {
                        Provider.of<MedicineProvider>(context, listen: false)
                            .insertsDummyMedicines();
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.remove_from_queue),
                      title: const Text('Clear Medecine'),
                      subtitle: const Text("delete drugs"),
                      onTap: () {
                        Provider.of<MedicineProvider>(context, listen: false).deleteAllMedicines();
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Add Patient'),
                      subtitle: const Text("fake data"),
                      onTap: () {
                        Provider.of<PatientProvider>(context, listen: false).registerDummyPatient();
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.remove_circle_outline),
                      title: const Text('Delete Patient'),
                      subtitle: const Text("clear all"),
                      onTap: () {
                        Provider.of<PatientProvider>(context, listen: false).deleteAllPatients();
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                  ],
                ),
              ),
              const DrawerFooter(),
            ],
          ),
        ),
      );
    });
  }
}

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: true);
    GoogleSignInAccount? user = authProvider.currentUser;

    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: Column(
          children: <Widget>[
            const Divider(),
            if (authProvider.isAuthorised)
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('SignOut'),
                  onTap: () async {
                    await authProvider.signOut();
                  }),
            if (!authProvider.isAuthorised)
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('SignIn'),
                  onTap: () async {
                    await authProvider.signIn();
                  }),
            const ListTile(
              title: Text('Developer'),
              subtitle: Text('Sudheer gupta'),
              trailing: Text('ver 0.1'),
            ),
          

          ],
        ));
  }
}
