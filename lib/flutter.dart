import 'dart:ui';
import 'package:flutter/material.dart';

class Flutter extends StatefulWidget {
  const Flutter({super.key});
  @override
  State<Flutter> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Flutter>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  bool obscure = true;
  late AnimationController _aniController;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // TODO: Firebase/Auth logic yahan add karo
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Welcome, $email')));
      // Example nav to placeholder home:
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const HomePlaceholder()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
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
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // Decorative soft circles
          Positioned(
            top: -size.width * 0.25,
            left: -size.width * 0.2,
            child: AnimatedBuilder(
              animation: _aniController,
              builder: (_, __) {
                return Transform.scale(
                  scale: 1 + 0.03 * (_aniController.value),
                  child: _SoftCircle(150, Colors.white.withOpacity(0.06)),
                );
              },
            ),
          ),
          Positioned(
            bottom: -size.width * 0.3,
            right: -size.width * 0.25,
            child: AnimatedBuilder(
              animation: _aniController,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(0, 8 * (_aniController.value - 0.5)),
                  child: _SoftCircle(220, Colors.white.withOpacity(0.05)),
                );
              },
            ),
          ),

          // Center content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App icon + title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _AppLogo(),
                      SizedBox(width: 12),
                      Text(
                        'Chatify',
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

                  // Glass card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // avatar
                              const CircleAvatar(
                                radius: 36,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto='
                                  'format&fit=crop&ixlib=rb-4.0.3&s=7c3a2f14a0b3b2b1a3f2a2d1b3c2a1f9',
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Email
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration(
                                  hint: 'Email...',
                                  icon: Icons.person,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Email is required'
                                    : null,
                                onSaved: (v) => email = v?.trim() ?? '',
                              ),
                              const SizedBox(height: 12),

                              // Password
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                obscureText: obscure,
                                decoration: _inputDecoration(
                                  hint: 'Password',
                                  icon: Icons.lock,
                                  suffix: IconButton(
                                    onPressed: () =>
                                        setState(() => obscure = !obscure),
                                    icon: Icon(
                                      obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                validator: (v) => (v == null || v.length < 6)
                                    ? 'Password must be atleast 6 characters'
                                    : null,
                                onSaved: (v) => password = v ?? '',
                              ),
                              const SizedBox(height: 8),

                              // forgot + remember row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot?',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Gradient login button
                              SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: _onLogin,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
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
                                    child: const Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Or continue with
                              Row(
                                children: const [
                                  Expanded(
                                    child: Divider(color: Colors.white24),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.white24),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Social row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _SocialIcon(
                                    icon: Icons.facebook,
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 12),
                                  _SocialIcon(
                                    icon: Icons.g_mobiledata,
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 12),
                                  _SocialIcon(icon: Icons.apple, onTap: () {}),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Signup prompt
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'No account?',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(color: Colors.white),
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

                  const SizedBox(height: 18),

                  // subtle footnote
                  const Text(
                    'Secure & encrypted — Chatify',
                    style: TextStyle(color: Colors.white70),
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

// small widgets below

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white70),
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
      borderSide: const BorderSide(color: Colors.white24),
    ),
  );
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
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8),
        ],
      ),
      child: const Icon(
        Icons.chat_bubble_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIcon({required this.icon, required this.onTap, super.key});
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
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Logged in — Home Screen')),
    );
  }
}
