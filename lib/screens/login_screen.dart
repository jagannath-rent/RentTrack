import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tenant/tenant_home.dart';
import 'tenant/tenant_signup_page.dart';
import 'owner/owner_home.dart';
import 'package:tenant_owner_app/screens/owner/owner_signup_page.dart';
import 'package:tenant_owner_app/theme/rentflow_colors.dart';

// ── RentFlow "certificate" palette (sourced from theme/rentflow_colors.dart) ──
const _ink = kRfInk;
const _ivory = kRfIvory;
const _ivoryDim = kRfIvoryDim;
const _gold = kRfGold;
const _goldDark = kRfGoldDark;
const _sapphire = kRfSapphire;
const _sapphireDk = kRfSapphireDk;
const _inkFaint = kRfInkFaint;
const _inkSoft = kRfInkSoft;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Tenant';
  bool _isLoading = false;
  bool _obscurePassword = true;

  Color get _accent => _selectedRole == 'Owner' ? _gold : _sapphire;
  Color get _accentDark => _selectedRole == 'Owner' ? _goldDark : _sapphireDk;

  void _login() async {
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (_selectedRole == 'Tenant') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TenantHome()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OwnerHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ink,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.85),
            radius: 1.1,
            colors: [Color(0xFF2A4F42), _ink],
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
                    color: _ivory.withOpacity(0.85),
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
                      _buildCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                if (_selectedRole == 'Tenant') _buildTenantFootnote(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── decorative corner bracket ──────────────────────────────
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
                ? const BorderSide(color: _gold, width: 2)
                : BorderSide.none,
            bottom: !top
                ? const BorderSide(color: _gold, width: 2)
                : BorderSide.none,
            left: left
                ? const BorderSide(color: _gold, width: 2)
                : BorderSide.none,
            right: !left
                ? const BorderSide(color: _gold, width: 2)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ── the certificate card ───────────────────────────────────
  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(34, 40, 34, 30),
      decoration: BoxDecoration(
        color: _ivory,
        border: Border.all(color: _gold.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // crest
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _accent, width: 1.5),
              ),
              child: Icon(Icons.apartment_rounded, color: _accent, size: 26),
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
              color: _ink,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 46,
              height: 1,
              color: _gold.withOpacity(0.35),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Rental management, formally recorded.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: _inkFaint,
            ),
          ),
          const SizedBox(height: 26),

          // role plaques
          Row(
            children: [
              Expanded(child: _rolePlaque('Owner', Icons.vpn_key_rounded)),
              const SizedBox(width: 10),
              Expanded(child: _rolePlaque('Tenant', Icons.apartment_rounded)),
            ],
          ),
          const SizedBox(height: 26),

          _buildLabel(
            _selectedRole == 'Owner'
                ? 'Email or mobile number'
                : 'Tenant ID or mobile number',
          ),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _idController,
            hint: _selectedRole == 'Owner'
                ? 'you@example.com or 98765 43210'
                : 'RFT-4821 or 98765 43210',
            icon: _selectedRole == 'Owner'
                ? Icons.mail_outline_rounded
                : Icons.badge_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          _buildLabel('Password'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _passwordController,
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePassword,
            suffix: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: _inkFaint,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: Checkbox(
                      value: false,
                      onChanged: (_) {},
                      activeColor: _accent,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Keep me signed in',
                    style: GoogleFonts.lora(fontSize: 12.5, color: _inkSoft),
                  ),
                ],
              ),
              Text(
                'Forgot password?',
                style: GoogleFonts.lora(
                  fontSize: 12.5,
                  color: _accentDark,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
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
                      'Log in as $_selectedRole',
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
            child: _selectedRole == 'Owner'
                ? RichText(
                    text: TextSpan(
                      style: GoogleFonts.lora(fontSize: 13.5, color: _inkSoft),
                      children: [
                        const TextSpan(text: 'New to RentFlow?  '),
                        TextSpan(
                          text: 'Register as an owner',
                          style: TextStyle(
                            color: _accentDark,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OwnerSignupPage(),
                              ),
                            ),
                        ),
                      ],
                    ),
                  )
                : RichText(
                    text: TextSpan(
                      style: GoogleFonts.lora(fontSize: 13, color: _inkSoft),
                      children: [
                        const TextSpan(text: 'First time here? '),
                        TextSpan(
                          text: 'Set up your password',
                          style: TextStyle(
                            color: _accentDark,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TenantSignupPage(),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _rolePlaque(String role, IconData icon) {
    final selected = _selectedRole == role;
    final accent = role == 'Owner' ? _gold : _sapphire;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? accent : Colors.transparent,
          border: Border.all(color: selected ? accent : _ink.withOpacity(0.18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: selected ? Colors.white : _inkSoft),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                role,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.lora(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : _inkSoft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantFootnote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "New tenant? Your property owner adds your details in RentFlow and sends you a unique Tenant ID by SMS.",
        textAlign: TextAlign.center,
        style: GoogleFonts.lora(
          fontSize: 12.5,
          color: _ivory.withOpacity(0.6),
          height: 1.5,
        ),
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
        color: _inkSoft,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _ink.withOpacity(0.18)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: GoogleFonts.lora(fontSize: 14.5, color: _ink),
        cursorColor: _accent,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lora(color: _inkFaint, fontSize: 14),
          prefixIcon: Icon(icon, color: _inkFaint, size: 20),
          suffixIcon: suffix,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _accent, width: 1.4),
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
