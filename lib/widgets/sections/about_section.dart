import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';
import '../glass_container.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _shimmer = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0B0C10),
            Color(0xFF111520),
            Color(0xFF0B0C10),
          ],
        ),
        border: Border(
          top: BorderSide(color: AppColors.primaryNeon.withAlpha(15)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 40, height: 1, color: AppColors.primaryNeon.withAlpha(80)),
                  const SizedBox(width: 16),
                  Text(
                    'ABOUT',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNeon.withAlpha(180),
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(width: 40, height: 1, color: AppColors.primaryNeon.withAlpha(80)),
                ],
              ),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.primaryNeon, Color(0xFF7B2FFF)],
                ).createShader(bounds),
                child: Text(
                  'WHAT IS SUROTSAV?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: isMobile ? 28 : 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Description in a glass card
              GlassContainer(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Surotsav is the premier cultural and technical festival of the year — a confluence of brilliant minds, extraordinary talent, and unbounded creativity. Join us for 3 days of non-stop excitement, learning, and celebration. Experience thrilling hackathons, mesmerizing performances, and an unforgettable journey that will leave you inspired.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 15 : 18,
                    height: 1.8,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 56),
              // Stats row
              Wrap(
                alignment: WrapAlignment.center,
                spacing: isMobile ? 24 : 60,
                runSpacing: 32,
                children: [
                  _buildStat('50+', 'Events', const Color(0xFF66FCF1)),
                  _buildStat('10K+', 'Attendees', const Color(0xFFC501E2)),
                  _buildStat('3', 'Days', const Color(0xFF7B2FFF)),
                  _buildStat('₹5L+', 'Prizes', const Color(0xFFFF6B9D)),
                ],
              ),
              const SizedBox(height: 56),
              // Feature highlights
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildFeatureChip(Icons.code_rounded, 'Hackathons'),
                  _buildFeatureChip(Icons.music_note_rounded, 'Live Performances'),
                  _buildFeatureChip(Icons.emoji_events_rounded, 'Competitions'),
                  _buildFeatureChip(Icons.groups_rounded, 'Workshops'),
                  _buildFeatureChip(Icons.restaurant_rounded, 'Food Stalls'),
                  _buildFeatureChip(Icons.celebration_rounded, 'DJ Night'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String number, String label, Color color) {
    return _HoverStat(number: number, label: label, color: color);
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.textMuted.withAlpha(40)),
        color: AppColors.cardBg.withAlpha(80),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryNeon),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverStat extends StatefulWidget {
  final String number;
  final String label;
  final Color color;

  const _HoverStat({
    required this.number,
    required this.label,
    required this.color,
  });

  @override
  State<_HoverStat> createState() => _HoverStatState();
}

class _HoverStatState extends State<_HoverStat> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? widget.color.withAlpha(100) : Colors.transparent,
          ),
          color: _hovered ? widget.color.withAlpha(15) : Colors.transparent,
        ),
        child: Column(
          children: [
            Text(
              widget.number,
              style: GoogleFonts.montserrat(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: widget.color,
                shadows: [
                  Shadow(
                    color: widget.color.withAlpha(80),
                    blurRadius: _hovered ? 15 : 0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get label => widget.label;
}
