import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

        // Key by user id so the role check re-runs only when the user changes.
        return _RoleRouter(key: ValueKey(session.user.id));
      },
    );
  }
}

class _RoleRouter extends StatefulWidget {
  const _RoleRouter({super.key});

  @override
  State<_RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<_RoleRouter> {
  final _auth = AuthService();
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = _checkOwner();
  }

  Future<bool> _checkOwner() async {
    final result = await _auth.isOwner();
    debugPrint('AuthGate: isOwner = $result');
    return result;
  }

  void _retry() {
    setState(() => _future = _checkOwner());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error: do NOT silently fall back to the Tenant screen.
        if (snap.hasError) {
          debugPrint('AuthGate ERROR: ${snap.error}');
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      'Could not verify your account.\n${snap.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Retry'),
                    ),
                    TextButton(
                      onPressed: () => _auth.signOut(),
                      child: const Text('Back to login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return snap.data == true ? const OwnerHome() : const TenantHome();
      },
    );
  }
}
