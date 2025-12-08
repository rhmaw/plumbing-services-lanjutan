import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // ukuran responsif
    double logoSize = isTablet ? 150 : 90;
    double spacing = isTablet ? 30 : 20;
    double fontTitle = isTablet ? 28 : 22;
    double inputFont = isTablet ? 20 : 16;
    double buttonFont = isTablet ? 20 : 16;

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND ATAS
          Positioned(
            top: -100,
            left: -60,
            child: Container(
              width: isTablet ? 350 : 220,
              height: isTablet ? 350 : 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ),

          // BACKGROUND BAWAH
          Positioned(
            bottom: -120,
            right: -70,
            child: Container(
              width: isTablet ? 400 : 250,
              height: isTablet ? 400 : 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.blue.withOpacity(0.35), Colors.transparent],
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? size.width * 0.2 : 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LOGO
                  Image.asset("assets/logo.png", width: logoSize),
                  const SizedBox(height: 10),

                  Text(
                    "PlumDev",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 26 : 20,
                    ),
                  ),

                  SizedBox(height: spacing * 2),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: fontTitle,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  SizedBox(height: spacing),

                  // EMAIL FIELD
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: inputFont),
                      decoration: InputDecoration(
                        icon: const Icon(Icons.email_outlined),
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                    ),
                  ),

                  SizedBox(height: spacing),

                  // PASSWORD FIELD
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: TextField(
                      obscureText: true,
                      style: TextStyle(fontSize: inputFont),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock_outline),
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                    ),
                  ),

                  SizedBox(height: spacing * 2),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 22 : 16,
                        ),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: buttonFont,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: spacing),

                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Belum punya akun? Daftar",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: inputFont,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: spacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
