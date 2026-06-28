import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

void main() {
  runApp(const VibelyApp());
}

class VibelyApp extends StatelessWidget {
  const VibelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const LoginPage(),
    );
  }
}

const kBg = Color(0xFF080B14);
const kOrb1 = Color(0xFF3D6BFF);
const kOrb2 = Color(0xFF9B59FF);
const kAccent = Color(0xFF4F7BFF);
const kAccentLight = Color(0xFF8FAAFF);

class BackgroundPainter extends CustomPainter {
  final double animValue;
  BackgroundPainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    _drawOrb(
      canvas,
      center: Offset(
        size.width * 0.78 + math.sin(animValue * 2 * math.pi) * 14,
        size.height * 0.18 + math.cos(animValue * 2 * math.pi) * 10,
      ),
      radius: size.width * 0.58,
      color: kOrb1.withOpacity(0.26),
    );
    _drawOrb(
      canvas,
      center: Offset(
        size.width * 0.12 + math.cos(animValue * 2 * math.pi) * 10,
        size.height * 0.82 + math.sin(animValue * 2 * math.pi) * 8,
      ),
      radius: size.width * 0.45,
      color: kOrb2.withOpacity(0.20),
    );
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          kOrb1.withOpacity(0.10),
          kOrb2.withOpacity(0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.42, size.width, 1));
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.42, size.width, 0.8), linePaint);

    final dotPaint = Paint()..color = kOrb1.withOpacity(0.08);
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 8; j++) {
        canvas.drawCircle(
          Offset(size.width * 0.60 + i * 26.0, size.height * 0.52 + j * 26.0),
          1.5,
          dotPaint,
        );
      }
    }
  }

  void _drawOrb(Canvas canvas,
      {required Offset center,
      required double radius,
      required Color color}) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withOpacity(0.06), Colors.transparent],
        stops: const [0.0, 0.50, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(BackgroundPainter old) => old.animValue != animValue;
}

class VibelyLogo extends StatelessWidget {
  const VibelyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/logo-vibely.png',
        width: 70,
        height: 70,
        fit: BoxFit.contain,
      ),
    );
  }
}

class VibelyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isFocused;
  final Function(bool) onFocusChange;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const VibelyTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isFocused,
    required this.onFocusChange,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.55),
              letterSpacing: 0.3,
            )),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: onFocusChange,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isFocused
                    ? kAccent.withOpacity(0.70)
                    : Colors.white.withOpacity(0.10),
                width: isFocused ? 1.2 : 0.8,
              ),
              color: isFocused
                  ? kAccent.withOpacity(0.07)
                  : Colors.white.withOpacity(0.04),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, letterSpacing: 0.2),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.22), fontSize: 15),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(icon,
                      size: 18,
                      color: isFocused
                          ? kAccentLight
                          : Colors.white.withOpacity(0.30)),
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 50, minHeight: 50),
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VibelyButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const VibelyButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kAccent, Color(0xFF7B5FFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: kAccent.withOpacity(0.40),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white)))
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SocialDivider extends StatelessWidget {
  const SocialDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child:
              Container(height: 0.6, color: Colors.white.withOpacity(0.09))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text('ou continuer avec',
            style: TextStyle(
                fontSize: 12.5,
                color: Colors.white.withOpacity(0.30),
                letterSpacing: 0.2)),
      ),
      Expanded(
          child:
              Container(height: 0.6, color: Colors.white.withOpacity(0.09))),
    ]);
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _socialBtn('Google', Icons.g_mobiledata_rounded),
      const SizedBox(width: 12),
      _socialBtn('Apple', Icons.apple_rounded),
      const SizedBox(width: 12),
      _socialBtn('GitHub', Icons.code_rounded),
    ]);
  }

  Widget _socialBtn(String label, IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: Colors.white.withOpacity(0.09), width: 0.8),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 20, color: Colors.white.withOpacity(0.70)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.60))),
          ]),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  bool _emailFocused = false;
  bool _passFocused = false;

  @override
  void initState() {
    super.initState();
    _orbController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _fadeController, curve: Curves.easeOutCubic));
    Future.delayed(
        const Duration(milliseconds: 200), () => _fadeController.forward());
  }

  @override
  void dispose() {
    _orbController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _isLoading = false);
  }

  void _goToRegister() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const RegisterPage(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _orbController,
              builder: (_, __) => CustomPaint(
                  painter: BackgroundPainter(_orbController.value)),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      const Center(child: VibelyLogo()),
                      const SizedBox(height: 24),

                      const Center(
                        child: Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: -1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Se connecter à Vibely',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.42),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                  width: 0.8),
                            ),
                            child: Column(
                              children: [
                                VibelyTextField(
                                  controller: _emailController,
                                  label: 'Adresse e-mail',
                                  hint: 'toi@exemple.com',
                                  icon: Icons.mail_outline_rounded,
                                  isFocused: _emailFocused,
                                  onFocusChange: (v) =>
                                      setState(() => _emailFocused = v),
                                  keyboardType:
                                      TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                VibelyTextField(
                                  controller: _passController,
                                  label: 'Mot de passe',
                                  hint: '••••••••',
                                  icon: Icons.lock_outline_rounded,
                                  isFocused: _passFocused,
                                  onFocusChange: (v) =>
                                      setState(() => _passFocused = v),
                                  obscure: _obscurePass,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 18,
                                      color:
                                          Colors.white.withOpacity(0.35),
                                    ),
                                    onPressed: () => setState(
                                        () => _obscurePass = !_obscurePass),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      'Mot de passe oublié ?',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: kAccentLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                VibelyButton(
                                  label: 'Se connecter',
                                  isLoading: _isLoading,
                                  onTap: _onLogin,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),
                      const SocialDivider(),
                      const SizedBox(height: 24),
                      const SocialButtons(),
                      const SizedBox(height: 36),

                      Center(
                        child: GestureDetector(
                          onTap: _goToRegister,
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Colors.white.withOpacity(0.38)),
                              children: const [
                                TextSpan(
                                    text: "Pas encore de compte ? "),
                                TextSpan(
                                  text: 'Créer un compte',
                                  style: TextStyle(
                                    color: kAccentLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  bool _nomFocused = false;
  bool _emailFocused = false;
  bool _passFocused = false;

  @override
  void initState() {
    super.initState();
    _orbController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _fadeController, curve: Curves.easeOutCubic));
    Future.delayed(
        const Duration(milliseconds: 150), () => _fadeController.forward());
  }

  @override
  void dispose() {
    _orbController.dispose();
    _fadeController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _orbController,
              builder: (_, __) => CustomPaint(
                  painter: BackgroundPainter(_orbController.value)),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const VibelyLogo(),
                      const SizedBox(height: 20),

                      const Text(
                        'Créer un compte',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.15,
                          letterSpacing: -1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rejoins Vibely et commence l'aventure",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.white.withOpacity(0.42),
                        ),
                      ),
                      const SizedBox(height: 28),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                  width: 0.8),
                            ),
                            child: Column(
                              children: [
                                VibelyTextField(
                                  controller: _nomController,
                                  label: 'Nom complet',
                                  hint: 'Jean Dupont',
                                  icon: Icons.person_outline_rounded,
                                  isFocused: _nomFocused,
                                  onFocusChange: (v) =>
                                      setState(() => _nomFocused = v),
                                ),
                                const SizedBox(height: 14),
                                VibelyTextField(
                                  controller: _emailController,
                                  label: 'Adresse e-mail',
                                  hint: 'toi@exemple.com',
                                  icon: Icons.mail_outline_rounded,
                                  isFocused: _emailFocused,
                                  onFocusChange: (v) =>
                                      setState(() => _emailFocused = v),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 14),
                                VibelyTextField(
                                  controller: _passController,
                                  label: 'Mot de passe',
                                  hint: '••••••••',
                                  icon: Icons.lock_outline_rounded,
                                  isFocused: _passFocused,
                                  onFocusChange: (v) =>
                                      setState(() => _passFocused = v),
                                  obscure: _obscurePass,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 18,
                                      color: Colors.white.withOpacity(0.35),
                                    ),
                                    onPressed: () => setState(
                                        () => _obscurePass = !_obscurePass),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                VibelyButton(
                                  label: "S'inscrire",
                                  isLoading: _isLoading,
                                  onTap: _onRegister,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),
                      const SocialDivider(),
                      const SizedBox(height: 18),
                      const SocialButtons(),
                      const SizedBox(height: 28),

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.38)),
                            children: const [
                              TextSpan(text: 'Déjà un compte ? '),
                              TextSpan(
                                text: 'Se connecter',
                                style: TextStyle(
                                  color: kAccentLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}