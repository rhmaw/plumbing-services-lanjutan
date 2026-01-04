import 'package:flutter/material.dart';

import '../../../../core/api/auth_service.dart';
import '../../../admin/presentation/pages/admin_home_page.dart';
import '../widgets/custom_text_field.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleAdminLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email & Password harus diisi!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    var result = await _authService.adminLogin(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result is Map<String, dynamic>) {
      if (result['role'] == 'admin') {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomePage(adminData: result),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bukan akun Admin!"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (result is String) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: Colors.red),
        );
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

          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black54),
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
                      letterSpacing: 0.5,
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

                  CustomTextField(
                    hintText: "Email Admin",
                    icon: Icons.email,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    hintText: "Password",
                    icon: Icons.lock,
                    isPassword: true,
                    controller: _passwordController,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAdminLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
