// main.dart
import 'package:dispensary/appConfig.dart';
import 'package:dispensary/providers/auth_provider.dart';
import 'package:dispensary/providers/dashboard_provider.dart';
import 'package:dispensary/providers/landing_provider.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:dispensary/screens/all_medicine_screen.dart';
import 'package:dispensary/screens/all_patients_screen.dart';
import 'package:dispensary/screens/dashboard_screen.dart';
import 'package:dispensary/services/google_drive_backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/providers/prescription_provider.dart';
import 'package:dispensary/screens/landing_screen.dart';
import 'package:dispensary/screens/registration_screen.dart';
import 'package:dispensary/screens/search_screen.dart';
import 'package:dispensary/services/database_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  await databaseService.initializeDatabase();
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  MyApp({required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PatientProvider(databaseService),
        ),
        ChangeNotifierProvider(
          create: (context) => PrescriptionProvider(databaseService),
        ),
        ChangeNotifierProvider(
          create: (context) => MedicineProvider(databaseService),
        ),
        ChangeNotifierProvider(
          create: (context) => LandingScreenProvider(databaseService),
        ),
        ChangeNotifierProvider(
          create: (context) => DashboardScreenProvider(databaseService),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(databaseService),
        ),
        // Add more providers as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(color: Colors.white), backgroundColor: Color(0xff6750a4), iconTheme: IconThemeData(color: Colors.white)),
          colorSchemeSeed: const Color(0xff6750a4),
          useMaterial3: true,
          snackBarTheme:
              const SnackBarThemeData(backgroundColor: Color(0xff6750a4)),
        ),
        initialRoute: '/test',
        routes: {
          '/dashboard': (context) => DashboardScreen(),
          '/': (context) => LandingScreen(),
          '/registration': (context) => RegistrationScreen(),
          '/search': (context) => SearchScreen(),
          '/allPatients': (context) => AllPatientsScreen(),
          '/allMedicine': (context) => AllMedicineScreen(),
          "/test": (context) => GoogleDriveTest()
        },
      ),
    );
  }
}
