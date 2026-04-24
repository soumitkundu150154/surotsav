import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/colors.dart';
import '../glass_container.dart';

class RegistrationSection extends StatefulWidget {
  const RegistrationSection({super.key});

  @override
  State<RegistrationSection> createState() => _RegistrationSectionState();
}

class _RegistrationSectionState extends State<RegistrationSection> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF151821),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: GlassContainer(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'REGISTER NOW',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryNeon,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: _inputDecoration('Full Name', Icons.person),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: _inputDecoration('Email Address', Icons.email),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    dropdownColor: AppColors.cardBg,
                    style: const TextStyle(color: AppColors.textMain),
                    decoration: _inputDecoration('Select Event', Icons.event),
                    items: ['Mobmania', 'Manthan', 'Dance Battle', 'All Events']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedEvent = val),
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration Successful!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryNeon,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'SUBMIT',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      prefixIcon: Icon(icon, color: AppColors.primaryNeon),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.textMuted.withAlpha(50)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryNeon),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
