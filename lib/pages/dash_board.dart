import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/countdown_section.dart';
import '../widgets/sections/events_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/team_section.dart';
import '../widgets/sections/registration_section.dart';
import '../widgets/sections/footer_section.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _eventsKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _teamKey = GlobalKey();
  final GlobalKey _registerKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/favicon.png', height: 50),
            // Text(
            //   'SUROTSAV',
            //   style: GoogleFonts.montserrat(
            //     fontWeight: FontWeight.w900,
            //     color: AppColors.primaryNeon,
            //     letterSpacing: 2,
            //   ),
            // ),
          ],
        ),
        actions: [
          _buildNavButton('Events', _eventsKey),
          _buildNavButton('About', _aboutKey),
          _buildNavButton('Team', _teamKey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () => _scrollToSection(_registerKey),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: AppColors.background,
              ),
              child: const Text('Register'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(
              key: _heroKey,
              onRegisterTap: () => _scrollToSection(_registerKey),
            ),
            const CountdownSection(),
            EventsSection(key: _eventsKey),
            AboutSection(key: _aboutKey),
            TeamSection(key: _teamKey),
            RegistrationSection(key: _registerKey),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, GlobalKey key) {
    return TextButton(
      onPressed: () => _scrollToSection(key),
      style: TextButton.styleFrom(foregroundColor: AppColors.textMain),
      child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
    );
  }
}
