import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenant_owner_app/theme/rentflow_colors.dart';

class TenantSignupPage extends StatefulWidget {
  const TenantSignupPage({super.key});

  @override
  State<TenantSignupPage> createState() => _TenantSignupPageState();
}

class _TenantSignupPageState extends State<TenantSignupPage> {
  final _tenantIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  void _activate() async {
    final id = _tenantIdController.text.trim();
    final pw = _passwordController.text;
    final confirm = _confirmController.text;

    if (id.isEmpty || pw.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }
    if (pw != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    if (pw.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // TODO: replace with a Supabase call that sets the password
    // against the Tenant ID record the owner already created.
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account activated — please log in')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kRfInk,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.85),
            radius: 1.1,
            colors: [Color(0xFF2A4F42), kRfInk],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Column(
              children: [
                Text(
                  'RENTFLOW · PROPERTY REGISTER',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.2,
                    color: kRfIvory.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 28),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _corner(top: true, left: true),
                      _corner(top: true, left: false),
                      _corner(top: false, left: true),
                      _corner(top: false, left: false),
                      _buildCard(context),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Don't have a Tenant ID? Ask your property owner to add you in RentFlow first.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 12.5,
                      color: kRfIvory.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _corner({required bool top, required bool left}) {
    return Positioned(
      top: top ? -1 : null,
      bottom: top ? null : -1,
      left: left ? -1 : null,
      right: left ? null : -1,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? const BorderSide(color: kRfGold, width: 2)
                : BorderSide.none,
            bottom: !top
                ? const BorderSide(color: kRfGold, width: 2)
                : BorderSide.none,
            left: left
                ? const BorderSide(color: kRfGold, width: 2)
                : BorderSide.none,
            right: !left
                ? const BorderSide(color: kRfGold, width: 2)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(34, 40, 34, 30),
      decoration: BoxDecoration(
        color: kRfIvory,
        border: Border.all(color: kRfGold.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kRfSapphire, width: 1.5),
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: kRfSapphire,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'RentFlow',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.2,
              color: kRfInk,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 46,
              height: 1,
              color: kRfGold.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tenant Account Activation',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: kRfInkFaint,
            ),
          ),
          const SizedBox(height: 26),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: kRfIvoryDim,
              border: Border.all(
                color: kRfGold.withValues(alpha: 0.35),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tenant ID format: ',
                  style: GoogleFonts.lora(fontSize: 12.5, color: kRfInkSoft),
                ),
                Text(
                  'RFT-4821',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: kRfSapphireDk,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          _buildLabel('Tenant ID'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _tenantIdController,
            hint: 'RFT-4821',
            icon: Icons.badge_outlined,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Find this on the SMS or email your owner sent when they added you.',
              style: GoogleFonts.lora(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: kRfInkFaint,
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel('Password'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _passwordController,
            hint: 'Create password',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePassword,
            suffix: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: kRfInkFaint,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 16),

          _buildLabel('Confirm Password'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _confirmController,
            hint: 'Repeat password',
            icon: Icons.lock_outline_rounded,
            obscure: _obscureConfirm,
            suffix: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: kRfInkFaint,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: 26),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _activate,
              style: ElevatedButton.styleFrom(
                backgroundColor: kRfSapphire,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Activate My Account',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 18),

          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.lora(fontSize: 13.5, color: kRfInkSoft),
                  children: [
                    const TextSpan(text: 'Already activated?  '),
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                        color: kRfSapphireDk,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.lora(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: kRfInkSoft,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kRfInk.withValues(alpha: 0.18)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.lora(fontSize: 14.5, color: kRfInk),
        cursorColor: kRfSapphire,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lora(color: kRfInkFaint, fontSize: 14),
          prefixIcon: Icon(icon, color: kRfInkFaint, size: 20),
          suffixIcon: suffix,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kRfSapphire, width: 1.4),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
