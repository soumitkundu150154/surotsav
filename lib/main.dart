import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surotsav/pages/dash_board.dart';
import 'package:surotsav/utils/colors.dart';

void main() {
  runApp(const FestApp());
}

class FestApp extends StatelessWidget {
  const FestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Surotsav 2026',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryNeon,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: AppColors.textMain,
          displayColor: AppColors.textMain,
        ),
      ),
      home: const DashBoard(),
    );
  }
}
