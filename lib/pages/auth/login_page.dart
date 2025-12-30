import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dashboard_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

  bool _isLoading = false;
  bool _obscure = true;

  // === WARNA SAMA DENGAN DASHBOARD ===
  static const Color cream = Color(0xFFFFF8EE);
  static const Color gold = Color(0xFFC9A24D);
  static const Color darkGold = Color(0xFF9E7C19);

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailC.text.trim(),
        password: _passwordC.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Terjadi kesalahan, coba lagi');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: darkGold,
      ),
    );
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
            color: darkGold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ===== ICON / HEADER =====
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [darkGold, gold]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Buku Tamu Digital",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkGold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Silakan login untuk melanjutkan",
                style: TextStyle(color: darkGold),
              ),

              const SizedBox(height: 30),

              // ===== CARD LOGIN =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // EMAIL
                    TextField(
                      controller: _emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
                    TextField(
                      controller: _passwordC,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => _obscure = !_obscure);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        onPressed:
                            _isLoading ? null : _login,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // REGISTER LINK
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  'Belum punya akun? Register',
                  style: TextStyle(
                    color: darkGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
