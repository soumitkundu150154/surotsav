import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';
import '../particle_background.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onRegisterTap;

  const HeroSection({super.key, required this.onRegisterTap});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;
  bool _buttonHovered = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: ParticleBackground(
        particleCount: isMobile ? 30 : 70,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_fadeAnim, _slideAnim, _floatAnim]),
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnim.value,
                child: Transform.translate(
                  offset: Offset(0, _slideAnim.value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Glowing orb behind title
                        Transform.translate(
                          offset: Offset(0, _floatAnim.value),
                          child: Container(
                            width: isMobile ? 120 : 180,
                            height: isMobile ? 120 : 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.primaryNeon.withAlpha(60),
                                  AppColors.secondaryNeon.withAlpha(30),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryNeon.withAlpha(40),
                                  blurRadius: 1000,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/logo_white.png',
                                height: 80,
                              ),
                              // Icon(
                              //   Icons.auto_awesome,
                              //   size: isMobile ? 48 : 64,
                              //   color: AppColors.primaryNeon.withAlpha(200),
                              // ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Main Title with gradient
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppColors.primaryNeon,
                              Color(0xFF7B2FFF),
                              AppColors.secondaryNeon,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'SUROTSAV',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: isMobile ? 48 : 80,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 8,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          '2 0 2 6',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: isMobile ? 28 : 48,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textMuted,
                            letterSpacing: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tagline
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: AppColors.primaryNeon.withAlpha(150),
                                width: 2,
                              ),
                              right: BorderSide(
                                color: AppColors.secondaryNeon.withAlpha(150),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            'The Ultimate Tech & Cultural Extravaganza',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 14 : 20,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // CTA Button with animated glow
                        AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (context, child) {
                            return MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _buttonHovered = true),
                              onExit: (_) =>
                                  setState(() => _buttonHovered = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.secondaryNeon.withAlpha(
                                        (_pulseAnim.value * 100).toInt(),
                                      ),
                                      blurRadius: _buttonHovered ? 30 : 15,
                                      spreadRadius: _buttonHovered ? 2 : 0,
                                    ),
                                    BoxShadow(
                                      color: AppColors.primaryNeon.withAlpha(
                                        (_pulseAnim.value * 50).toInt(),
                                      ),
                                      blurRadius: 25,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: widget.onRegisterTap,
                                  style:
                                      ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: AppColors.textMain,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobile ? 32 : 48,
                                          vertical: isMobile ? 16 : 22,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        elevation: 0,
                                      ).copyWith(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              Colors.transparent,
                                            ),
                                      ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.secondaryNeon,
                                          Color(0xFF7B2FFF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 24 : 40,
                                        vertical: isMobile ? 14 : 18,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'REGISTER NOW',
                                            style: GoogleFonts.inter(
                                              fontSize: isMobile ? 14 : 18,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            transform:
                                                Matrix4.translationValues(
                                                  _buttonHovered ? 6 : 0,
                                                  0,
                                                  0,
                                                ),
                                            child: const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 64),
                        // Scroll indicator
                        AnimatedBuilder(
                          animation: _floatAnim,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatAnim.value * 0.5),
                              child: Column(
                                children: [
                                  Text(
                                    'SCROLL TO EXPLORE',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      letterSpacing: 3,
                                      color: AppColors.textMuted.withAlpha(120),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.primaryNeon.withAlpha(120),
                                    size: 28,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
