import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plumbing_services_pml_kel4/presentation/pages/user/user_dasboard.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

 
  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("https://your-api.com/login"),
        body: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
 
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", data["token"]);
          await prefs.setString("username", data["user"]["username"]);
          await prefs.setInt("user_id", data["user"]["id"]);

       
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserDashboard()),
          );
        } else {
          _showError(data["message"]);
        }
      } else {
        _showError("Login gagal. Coba lagi.");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showError("Terjadi kesalahan: $e");
    }
  }


  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Gagal"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.lock, size: 80, color: Colors.blue),

                const SizedBox(height: 20),
                const Text(
                  "User Login",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                     
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Email tidak boleh kosong" : null,
                      ),

                      const SizedBox(height: 20),

                      
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Password tidak boleh kosong" : null,
                      ),

                      const SizedBox(height: 30),

                     
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : loginUser,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(14),
                            backgroundColor: Colors.blue,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "MASUK",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
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
}
