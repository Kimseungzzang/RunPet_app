import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runpet_app/state/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _registerMode = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('RunPet Login')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_registerMode ? 'Create account' : 'Sign in', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          if (_registerMode) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
          if (authState.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              authState.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: authState.isLoading
                ? null
                : () async {
                    final username = _usernameController.text.trim();
                    final password = _passwordController.text.trim();
                    if (username.isEmpty || password.isEmpty) return;

                    if (_registerMode) {
                      final displayName = _displayNameController.text.trim().isEmpty
                          ? username
                          : _displayNameController.text.trim();
                      await authController.registerAndLogin(
                        username: username,
                        password: password,
                        displayName: displayName,
                      );
                    } else {
                      await authController.login(
                        username: username,
                        password: password,
                      );
                    }
                  },
            child: Text(authState.isLoading ? 'Loading...' : (_registerMode ? 'Register & Login' : 'Login')),
          ),
          TextButton(
            onPressed: authState.isLoading
                ? null
                : () {
                    setState(() => _registerMode = !_registerMode);
                  },
            child: Text(_registerMode ? 'Use existing account' : 'Create new account'),
          ),
        ],
      ),
    );
  }
}
