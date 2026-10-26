import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tenant_owner_app/services/auth_service.dart';
import 'package:tenant_owner_app/screens/login_screen.dart';
import 'package:tenant_owner_app/screens/owner/owner_home.dart';
import 'package:tenant_owner_app/screens/tenant/tenant_home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, _) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session == null) return const LoginScreen();

        return FutureBuilder<String?>(
          future: AuthService().getMyRole(),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return snap.data == 'owner'
                ? const OwnerHome()
                : const TenantHome();
          },
        );
      },
    );
  }
}
