import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 100, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0E14),
        border: Border(top: BorderSide(color: AppColors.secondaryNeon.withAlpha(15))),
      ),
      child: Column(
        children: [
          _sectionLabel('TEAM', AppColors.secondaryNeon),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.secondaryNeon, Color(0xFF7B2FFF), AppColors.primaryNeon],
            ).createShader(b),
            child: Text('MEET THE CREW', textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: isMobile ? 28 : 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
          ),
          const SizedBox(height: 16),
          Text('The brilliant minds behind the magic', style: GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted.withAlpha(150), letterSpacing: 1)),
          SizedBox(height: isMobile ? 40 : 64),
          Wrap(spacing: 28, runSpacing: 28, alignment: WrapAlignment.center, children: const [
            _TeamCard(name: 'Alice', role: 'Lead Organizer', icon: Icons.workspace_premium_rounded, colors: [Color(0xFFFFD700), Color(0xFFFF8C00)]),
            _TeamCard(name: 'Bob', role: 'Technical Head', icon: Icons.terminal_rounded, colors: [Color(0xFF66FCF1), Color(0xFF2979FF)]),
            _TeamCard(name: 'Charlie', role: 'Design Lead', icon: Icons.design_services_rounded, colors: [Color(0xFFC501E2), Color(0xFF7B2FFF)]),
            _TeamCard(name: 'Diana', role: 'Marketing Head', icon: Icons.campaign_rounded, colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)]),
          ]),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 40, height: 1, color: color.withAlpha(80)),
      const SizedBox(width: 16),
      Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: color.withAlpha(180), letterSpacing: 4)),
      const SizedBox(width: 16),
      Container(width: 40, height: 1, color: color.withAlpha(80)),
    ]);
  }
}

class _TeamCard extends StatefulWidget {
  final String name, role;
  final IconData icon;
  final List<Color> colors;
  const _TeamCard({required this.name, required this.role, required this.icon, required this.colors});
  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 240,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.cardBg.withAlpha(180), AppColors.background.withAlpha(220)]),
            border: Border.all(color: _hovered ? widget.colors[0].withAlpha(100) : Colors.white.withAlpha(15)),
            boxShadow: [
              if (_hovered) BoxShadow(color: widget.colors[0].withAlpha(50), blurRadius: 25),
              BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: widget.colors), boxShadow: [BoxShadow(color: widget.colors[0].withAlpha(60), blurRadius: 15)]),
              child: Icon(widget.icon, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(widget.name, style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textMain)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: widget.colors[0].withAlpha(20), border: Border.all(color: widget.colors[0].withAlpha(60))),
              child: Text(widget.role, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: widget.colors[0])),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _socialIcon(Icons.link_rounded),
              const SizedBox(width: 12),
              _socialIcon(Icons.alternate_email_rounded),
              const SizedBox(width: 12),
              _socialIcon(Icons.code_rounded),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon) => Container(
    width: 32, height: 32,
    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.cardBg.withAlpha(150), border: Border.all(color: AppColors.textMuted.withAlpha(30))),
    child: Icon(icon, size: 14, color: AppColors.textMuted),
  );
}
