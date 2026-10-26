import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tenant_owner_app/services/auth_service.dart';
import 'package:tenant_owner_app/theme/rentflow_colors.dart';

class OwnerSignupPage extends StatefulWidget {
  const OwnerSignupPage({super.key});

  @override
  State<OwnerSignupPage> createState() => _OwnerSignupPageState();
}

class _OwnerSignupPageState extends State<OwnerSignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    debugPrint('>>> OWNER SIGNUP _register v2 called');

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.replaceAll(RegExp(r'\s'), '');
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Enter a valid email address');
      return;
    }
    if (phone.replaceAll(RegExp(r'\D'), '').length < 7) {
      _showMessage('Enter a valid phone number');
      return;
    }
    if (password.length < 8) {
      _showMessage('Password must be at least 8 characters');
      return;
    }
    if (password != confirm) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await AuthService().signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: 'owner',
      );
      if (!mounted) return;
      if (res.session != null) {
        // AuthGate (the root screen) switches to OwnerHome automatically.
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        _showMessage('Account created. Verify your email, then log in.');
      }
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      _showMessage('Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
                      _buildCard(),
                    ],
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

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(34, 36, 34, 30),
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
          const Center(
            child: Icon(Icons.vpn_key_rounded, color: kRfGoldDark, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            'Create an Owner Account',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: kRfInk,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Register your details to manage your rental properties.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 13, color: kRfInkFaint),
          ),
          const SizedBox(height: 26),
          _buildLabel('Full name'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _nameController,
            hint: 'Your name',
            icon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          _buildLabel('Email address'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _emailController,
            hint: 'you@example.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildLabel('Mobile number'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _phoneController,
            hint: '98765 43210',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildLabel('Password'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _passwordController,
            hint: 'At least 8 characters',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePassword,
            suffix: IconButton(
              tooltip: _obscurePassword ? 'Show password' : 'Hide password',
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
          _buildLabel('Confirm password'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: _confirmController,
            hint: 'Repeat your password',
            icon: Icons.lock_outline_rounded,
            obscure: _obscureConfirm,
            suffix: IconButton(
              tooltip: _obscureConfirm ? 'Show password' : 'Hide password',
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
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: kRfGoldDark,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Create Owner Account',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Already registered? Log in',
                style: GoogleFonts.lora(
                  fontSize: 13.5,
                  color: kRfSapphireDk,
                  decoration: TextDecoration.underline,
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
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
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
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: GoogleFonts.lora(fontSize: 14.5, color: kRfInk),
        cursorColor: kRfGoldDark,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lora(color: kRfInkFaint, fontSize: 14),
          prefixIcon: Icon(icon, color: kRfInkFaint, size: 20),
          suffixIcon: suffix,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kRfGoldDark, width: 1.4),
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
