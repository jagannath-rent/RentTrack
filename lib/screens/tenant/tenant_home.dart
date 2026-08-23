import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantHome extends StatelessWidget {
  const TenantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, Tenant!',
                style: GoogleFonts.poppins(
                  fontSize: 26, fontWeight: FontWeight.w700)),
              Text('Welcome to your dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFF8E8E93))),
            ],
          ),
        ),
      ),
    );
  }
}