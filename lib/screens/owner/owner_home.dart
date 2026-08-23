import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenant_owner_app/theme/rentflow_colors.dart';

/// Placeholder Owner dashboard.
/// Replace the body of this file with your real dashboard whenever
/// it's ready — login_screen.dart only needs a class named `OwnerHome`
/// at this import path (screens/owner/owner_home.dart), so nothing
/// else needs to change when you swap this out.
class OwnerHome extends StatelessWidget {
  const OwnerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kRfIvoryDim,
      appBar: AppBar(
        backgroundColor: kRfInk,
        foregroundColor: kRfIvory,
        title: Text(
          'Owner Dashboard',
          style: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.apartment_rounded, size: 48, color: kRfGold),
              const SizedBox(height: 16),
              Text(
                'Owner Dashboard',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: kRfInk,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This is a placeholder screen — you\'re logged in as an owner. '
                'Replace this file\'s body with your real properties/tenants/rent dashboard.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(fontSize: 13.5, color: kRfInkSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
