import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    final ok = context.read<AppState>().login(_email.text.trim(), _pass.text.trim());
    if (mounted) {
      setState(() => _loading = false);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Password must be 6+ characters'), backgroundColor: kError, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF006D77), Color(0xFF004D56)]),
            ),
          ),
          // Top illustration
          Positioned(top: 0, left: 0, right: 0, child: SafeArea(
            child: Padding(padding: const EdgeInsets.only(top: 32),
              child: Column(children: [
                Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.location_searching, size: 48, color: Colors.white)),
                const SizedBox(height: 12),
                const Text('Campus Rescue', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(height: 4),
                Text('Help reunite lost & found items', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              ]),
            ),
          )),
          // Glass card
          Align(alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 240),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                child: Form(
                  key: _form,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
                    const Text('Welcome Back 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kTextDark)),
                    const SizedBox(height: 4),
                    const Text('Sign in to continue', style: TextStyle(color: kTextMedium)),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined, color: kPrimary)),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pass,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: kPrimary),
                        suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kTextMedium), onPressed: () => setState(() => _obscure = !_obscure)),
                      ),
                      validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(child: GestureDetector(
                      onTap: () { HapticFeedback.selectionClick(); Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())); },
                      child: RichText(text: const TextSpan(children: [
                        TextSpan(text: "Don't have an account? ", style: TextStyle(color: kTextMedium)),
                        TextSpan(text: 'Register', style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700)),
                      ])),
                    )),
                  ]),
                ),
              ),
            ),
          ),
          if (_loading) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: Colors.white))),
        ],
      ),
    );
  }
}
