import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';
import '../glass_container.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 100,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0E14),
        border: Border(
          top: BorderSide(color: AppColors.secondaryNeon.withAlpha(15)),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 40, height: 1, color: AppColors.secondaryNeon.withAlpha(80)),
              const SizedBox(width: 16),
              Text(
                'EVENTS',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryNeon.withAlpha(180),
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(width: 16),
              Container(width: 40, height: 1, color: AppColors.secondaryNeon.withAlpha(80)),
            ],
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.secondaryNeon, Color(0xFF7B2FFF), AppColors.primaryNeon],
            ).createShader(bounds),
            child: Text(
              'FEATURED EVENTS',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 28 : 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Compete. Create. Celebrate.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textMuted.withAlpha(150),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: isMobile ? 40 : 64),
          Wrap(
            spacing: 28,
            runSpacing: 28,
            alignment: WrapAlignment.center,
            children: [
              _EventCard(
                title: 'Mobmania',
                description: 'The ultimate mobile gaming showdown. Battle your way to the top!',
                icon: Icons.sports_esports,
                gradientColors: const [Color(0xFF00E5FF), Color(0xFF2979FF)],
              ),
              _EventCard(
                title: 'Manthan',
                description: 'A 24-hour hackathon to build the next revolutionary tech.',
                icon: Icons.code_rounded,
                gradientColors: const [Color(0xFF7B2FFF), Color(0xFFC501E2)],
              ),
              _EventCard(
                title: 'Dance Battle',
                description: 'Showcase your moves and steal the spotlight on stage.',
                icon: Icons.music_note_rounded,
                gradientColors: const [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
              ),
              _EventCard(
                title: 'Robo Wars',
                description: 'Build your bot and dominate the arena in epic battles.',
                icon: Icons.smart_toy_rounded,
                gradientColors: const [Color(0xFF66FCF1), Color(0xFF45A29E)],
              ),
              _EventCard(
                title: 'Quiz Quest',
                description: 'Test your knowledge across science, tech, and pop culture.',
                icon: Icons.quiz_rounded,
                gradientColors: const [Color(0xFFFFD700), Color(0xFFFF8C00)],
              ),
              _EventCard(
                title: 'Art Fusion',
                description: 'Where creativity meets canvas. Express, inspire, create.',
                icon: Icons.palette_rounded,
                gradientColors: const [Color(0xFFE040FB), Color(0xFF7C4DFF)],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const _EventCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: isMobile ? double.infinity : 320,
              constraints: BoxConstraints(maxWidth: isMobile ? 400 : 320),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors[0]
                        .withAlpha((_glowAnim.value * 80).toInt()),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withAlpha(80),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.cardBg.withAlpha(220),
                        AppColors.background.withAlpha(240),
                      ],
                    ),
                    border: Border.all(
                      color: widget.gradientColors[0]
                          .withAlpha(40 + (_glowAnim.value * 60).toInt()),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon with gradient background
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: widget.gradientColors,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.gradientColors[0].withAlpha(60),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Join button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: _isHovered
                                ? widget.gradientColors
                                : [Colors.transparent, Colors.transparent],
                          ),
                          border: Border.all(
                            color: widget.gradientColors[0].withAlpha(150),
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'JOIN NOW',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: _isHovered
                                          ? Colors.white
                                          : widget.gradientColors[0],
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                    color: _isHovered
                                        ? Colors.white
                                        : widget.gradientColors[0],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
