// main.dart
import 'package:dispensary/appConfig.dart';
import 'package:dispensary/providers/medicine_provider.dart';
import 'package:dispensary/screens/all_medicine_screen.dart';
import 'package:dispensary/screens/all_patients_screen.dart';
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
        // Add more providers as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4),
          useMaterial3: true,
          snackBarTheme:
              const SnackBarThemeData(backgroundColor: Color(0xff6750a4)),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LandingScreen(),
          '/registration': (context) => RegistrationScreen(),
          '/search': (context) => SearchScreen(),
          '/allPatients': (context) => AllPatientsScreen(),
          '/allMedicine': (context) => AllMedicineScreen()
        },
      ),
    );
  }
}
