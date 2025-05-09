import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:health_reports_comparator_gemini/src/screens/report_comparison_screen.dart';

Future<void> main() async{
  await dotenv.load(fileName: "/Users/admin/IdeaProjects/health_reports_comparator_gemini/.env");
  Gemini.init(apiKey: dotenv.get('GEMINI_KEY'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Reports Comparator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ReportComparisonScreen(),
    );
  }
}
