import 'dart:ui';

import 'package:chat_box/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Welcome, $email")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          ///Gradient background color
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.8, -1),
                end: Alignment(1, 0.8),
                colors: [
                  Color(0xFF2E1052),
                  Color(0xFF6A3AA0),
                  Color(0xFFFF7A7A),
                ],
              ),
            ),
          ),

          ///Decorative soft circles
          Positioned(
            top: -size.width * 0.25,
            left: -size.width * 0.2,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, _) {
                return Transform.scale(
                  scale: 1 + 0.03 * (_animationController.value),
                  child: _SoftCircle(150, Colors.white.withOpacity(0.06)),
                );
              },
            ),
          ),
          Positioned(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, _) {
                return Transform.translate(
                  offset: Offset(0, 8 * (_animationController.value - 0.5)),
                  child: _SoftCircle(150, Colors.white.withOpacity(0.05)),
                );
              },
            ),
          ),

          ///Center content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///App icon + title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AppLogo(),
                      SizedBox(width: 12),
                      Text(
                        "Chatify",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  ///Glass card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto='
                                  'format&fit=crop&ixlib=rb-4.0.3&s=7c3a2f14a0b3b2b1a3f2a2d1b3c2a1f9',
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: 12),

                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: _inputDecoration(
                                  hint: "Email",
                                  icon: Icons.person,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is required";
                                  }
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  ).hasMatch(value)) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) =>
                                    email = newValue?.trim() ?? '',
                              ),

                              SizedBox(height: 12),

                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: _inputDecoration(
                                  hint: "Password",
                                  icon: Icons.password,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  if (value.length > 8) {
                                    return "Password must be atleast 8 characters";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) =>
                                    password = newValue?.trim() ?? '',
                              ),

                              SizedBox(height: 12),

                              ///Remember + forgot
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Icon(Icons.check_box),
                                  // Text("Remember me"),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot?",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),

                              SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: _onLogin,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF56CCF2),
                                          Color(0xFF2F80ED),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: Colors.white30),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.white30),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _SocialIcons(
                                    icon: Icons.g_mobiledata,
                                    onTap: () {},
                                  ),
                                ],
                              ),

                              SizedBox(height: 8),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No account?",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _SoftCircle(this.size, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFFc371), Color(0xFFFF5F6D)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8),
        ],
      ),
      child: Icon(
        Icons.chat_bubble_outline_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.white70),
    prefixIcon: Icon(icon, color: Colors.white70),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white.withOpacity(0.04),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white24),
    ),
  );
}

class _SocialIcons extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIcons({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 40),
      ),
    );
  }
}
