import 'package:dispensary/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:dispensary/providers/patient_provider.dart';
import 'package:dispensary/providers/prescription_provider.dart';
import 'package:dispensary/services/database_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  await databaseService.initializeDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => PrescriptionProvider()),
        // Add more providers as needed
      ],
      child: MaterialApp(
        title: 'Dispensary App',
        initialRoute: '/',
        routes: {
          '/': (context) => LandingScreen(),
          //'/registration': (context) => RegistrationScreen(),
          // '/search': (context) => SearchScreen(),
        },
      ),
    );
  }
}
