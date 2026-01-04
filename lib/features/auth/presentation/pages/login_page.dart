import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/api/auth_service.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/pages/worker_service_page.dart';
import '../widgets/custom_text_field.dart';
import 'register_page.dart';
import 'admin_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email dan Password harus diisi"), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    try {
      var result = await _authService.login(_emailController.text, _passwordController.text);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result is Map<String, dynamic>) {
        final userData = result['user'] ?? result;

        String role = userData['role']?.toString().toLowerCase() ?? 'user';
        String status = userData['status']?.toString().toLowerCase() ?? '';

        if (role == 'worker') {
          if (status == 'approved' || status == 'accepted' || status.isEmpty) {
            if(status.isEmpty) userData['status'] = 'Approved'; 
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkerServicePage(userData: userData)));
          } else if (status == 'rejected') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Akun Worker Ditolak. Masuk sebagai User."), backgroundColor: Colors.orange));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userData: userData)));
          } else {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userData: userData)));
          }
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userData: userData)));
        }

      } else if (result is String) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result), backgroundColor: Colors.red));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Terjadi kesalahan format data sistem"), backgroundColor: Colors.red));
      }
    } catch (e) {
      if(mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF6495ED); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.shade200.withOpacity(0.5),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    brandBlue.withOpacity(0.4),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.build_rounded,
                    size: 70, 
                    color: Color(0xFF0066FF),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "PlumDev",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF0066FF),
                      letterSpacing: 0.5
                    ),
                  ),

                  const SizedBox(height: 60),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: brandBlue, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(hintText: "Email", icon: Icons.email, controller: _emailController),
                  const SizedBox(height: 15),
                  CustomTextField(hintText: "Password", icon: Icons.lock, isPassword: true, controller: _passwordController),
                  
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity, 
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text(
                            "Login", 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 16, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                    child: RichText(
                      text: const TextSpan(
                        text: "Belum punya akun? ",
                        style: TextStyle(color: Color(0xFF8FA1B4), fontSize: 14), 
                        children: [
                          TextSpan(
                            text: "Daftar",
                            style: TextStyle(color: brandBlue, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginPage())),
                    child: const Text(
                      "Masuk sebagai Admin",
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                        fontSize: 13
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
}