import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenant_owner_app/screens/login_screen.dart';
import 'package:tenant_owner_app/services/auth_service.dart';

class TenantHome extends StatelessWidget {
  const TenantHome({super.key});

  Future<void> _backToLogin(BuildContext context) async {
    await AuthService().signOut();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

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
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Back to login',
                onPressed: () => _backToLogin(context),
              ),
              const SizedBox(height: 8),
              Text(
                'Hello, Tenant!',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Welcome to your dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
