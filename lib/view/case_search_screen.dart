import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CaseSearchScreen extends StatelessWidget {
  const CaseSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Case Search',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF0D6EFD),
      ),
      body: Center(
        child: Text(
          '🔍 Case Search Screen (Mock)',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
