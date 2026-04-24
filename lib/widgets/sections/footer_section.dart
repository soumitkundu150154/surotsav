import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: AppColors.textMuted),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: AppColors.textMuted),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.link, color: AppColors.textMuted),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Contact us: info@surotsav.com | +91 98765 43210',
            style: GoogleFonts.inter(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Text(
            '© 2026 Surotsav. All Rights Reserved.',
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
