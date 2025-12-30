import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirmC = TextEditingController();

  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  // === WARNA ===
  static const Color cream = Color(0xFFFFF8EE);
  static const Color gold = Color(0xFFC9A24D);
  static const Color darkGold = Color(0xFF9E7C19);

  Future<void> _register() async {
    if (_emailC.text.isEmpty ||
        _passwordC.text.isEmpty ||
        _confirmC.text.isEmpty) {
      _showError('Semua field wajib diisi');
      return;
    }

    if (_passwordC.text.length < 6) {
      _showError('Password minimal 6 karakter');
      return;
    }

    if (_passwordC.text != _confirmC.text) {
      _showError('Password tidak sama');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _emailC.text.trim(),
        password: _passwordC.text,
      );

      // === EMAIL VERIFICATION AKTIF ===
      if (res.session == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi berhasil. Silakan cek email untuk verifikasi.',
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        Navigator.pop(context); // balik ke Login
        return;
      }

      // === JIKA EMAIL VERIFICATION OFF ===
      if (!mounted) return;
      Navigator.pop(context);
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
    _confirmC.dispose();
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
          'Register',
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
              // ===== ICON HEADER =====
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [darkGold, gold]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Buat Akun Baru",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkGold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Daftarkan akun untuk melanjutkan",
                style: TextStyle(color: darkGold),
              ),

              const SizedBox(height: 30),

              // ===== CARD REGISTER =====
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
                      obscureText: _obscurePass,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(
                                () => _obscurePass = !_obscurePass);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // CONFIRM PASSWORD
                    TextField(
                      controller: _confirmC,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password',
                        prefixIcon:
                            const Icon(Icons.lock_reset_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() =>
                                _obscureConfirm = !_obscureConfirm);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // REGISTER BUTTON
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
                            _isLoading ? null : _register,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Register',
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

              // BACK TO LOGIN
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Sudah punya akun? Login',
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
