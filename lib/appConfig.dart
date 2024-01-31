import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String appName = dotenv.env['app_name'] ?? "";
  static const int PageSize = 10;
  static const int PrescriptionSize = 2;
  static String prescriptionPDFAuther = dotenv.env['prescription_pdf_auther'] ?? "";
  static String creator = dotenv.env['pdf_creator'] ?? "";
  static String clinicAddress = dotenv.env['clinic_address'] ?? "";
  static String clinicMobile = dotenv.env['clinic_mobile'] ?? "";
  // docter specifc details
  static String nameOfDocter = dotenv.env['docter'] ?? "";
  static String nameOfClinic = dotenv.env['clinic_name'] ?? "";
  static String addressLine1 = dotenv.env['clinic_address_line1'] ?? "";
  static String addressLine2 = dotenv.env['clinic_address_line2'] ?? "";
  static String addressLine3 = dotenv.env['clinic_address_line3'] ?? "";
  static String regNO = dotenv.env['reg_no'] ?? "";
  static String degree = dotenv.env['degree'] ?? "";
  static String position = dotenv.env['position'] ?? "";
 
  
}
