import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';
import '../glass_container.dart';

class CountdownSection extends StatefulWidget {
  const CountdownSection({super.key});

  @override
  State<CountdownSection> createState() => _CountdownSectionState();
}

class _CountdownSectionState extends State<CountdownSection>
    with TickerProviderStateMixin {
  late Timer _timer;
  Duration _timeLeft = const Duration();
  final DateTime _eventDate = DateTime(2026, 5, 13, 10, 0, 0);

  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  // Track previous seconds for flip animation
  int _prevSeconds = -1;
  int _prevMinutes = -1;
  int _prevHours = -1;
  int _prevDays = -1;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _updateTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  void _updateTimer() {
    final now = DateTime.now();
    if (_eventDate.isAfter(now)) {
      setState(() {
        _timeLeft = _eventDate.difference(now);
      });
    } else {
      setState(() {
        _timeLeft = const Duration();
      });
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 100,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
              top: BorderSide(
                color: AppColors.primaryNeon.withAlpha(20),
              ),
            ),
          ),
          child: Column(
            children: [
              // Section label
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 1,
                    color: AppColors.primaryNeon.withAlpha(80),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'COUNTDOWN',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNeon.withAlpha(180),
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 1,
                    color: AppColors.primaryNeon.withAlpha(80),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.primaryNeon, AppColors.secondaryNeon],
                ).createShader(bounds),
                child: Text(
                  'THE FEST BEGINS IN',
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 24 : 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 32 : 56),
              // Timer cards
              Wrap(
                spacing: isMobile ? 12 : 24,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildFlipCard(days, _prevDays, 'DAYS', isMobile),
                  _buildSeparator(isMobile),
                  _buildFlipCard(hours, _prevHours, 'HOURS', isMobile),
                  _buildSeparator(isMobile),
                  _buildFlipCard(minutes, _prevMinutes, 'MINUTES', isMobile),
                  _buildSeparator(isMobile),
                  _buildFlipCard(seconds, _prevSeconds, 'SECONDS', isMobile),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeparator(bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 24 : 32),
      child: Text(
        ':',
        style: GoogleFonts.montserrat(
          fontSize: isMobile ? 32 : 48,
          fontWeight: FontWeight.w300,
          color: AppColors.primaryNeon.withAlpha(120),
        ),
      ),
    );
  }

  Widget _buildFlipCard(int value, int prevValue, String label, bool isMobile) {
    final displayVal = value.toString().padLeft(2, '0');
    final cardWidth = isMobile ? 80.0 : 120.0;
    final cardHeight = isMobile ? 90.0 : 130.0;

    return Column(
      children: [
        // The timer card
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                )),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey<String>('$label-$displayVal'),
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cardBg.withAlpha(200),
                  AppColors.background.withAlpha(240),
                ],
              ),
              border: Border.all(
                color: AppColors.primaryNeon.withAlpha(
                  (40 + _glowAnim.value * 30).toInt(),
                ),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryNeon.withAlpha(
                    (_glowAnim.value * 25).toInt(),
                  ),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayVal,
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 36 : 52,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryNeon.withAlpha(100),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 10 : 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted.withAlpha(180),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
