// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class SplashToLoginScreen extends StatefulWidget {
  const SplashToLoginScreen({super.key});

  @override
  State<SplashToLoginScreen> createState() => _SplashToLoginScreenState();
}

class _SplashToLoginScreenState extends State<SplashToLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Offset> _slideAnimation;

  // TAMBAHKAN: State untuk auth check
  bool _isCheckingAuth = false;
  String _statusMessage = 'Memuat aplikasi...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthenticationAndNavigate();
  }

  void _initializeAnimations() {
    // Setup animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Multiple animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.bounceOut),
      ),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF4F7DF9),
      end: const Color(0xFF3366CC),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Start animations
    _controller.forward();
  }

  // TAMBAHKAN: Fungsi untuk cek authentication
  Future<void> _checkAuthenticationAndNavigate() async {
    setState(() {
      _isCheckingAuth = true;
      _statusMessage = 'Memeriksa sesi login...';
    });

    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      final isLoggedIn = await AuthService.isLoggedIn();
      final user = await AuthService.getUser();

      print('🔍 Splash Screen Auth Check:');
      print('   Is logged in: $isLoggedIn');
      print('   User: ${user?.email}');

      if (mounted) {
        if (isLoggedIn && user != null) {
          setState(() {
            _statusMessage = 'Login terdeteksi, mengarahkan...';
          });

          await Future.delayed(const Duration(milliseconds: 800));

          _navigateToHome(user);
        } else {
          setState(() {
            _statusMessage = 'Mengarahkan ke halaman login...';
          });

          await Future.delayed(const Duration(milliseconds: 800));

          _navigateToLogin();
        }
      }
    } catch (e) {
      print('❌ Splash auth check error: $e');
      if (mounted) {
        _navigateToLogin();
      }
    } finally {
      setState(() {
        _isCheckingAuth = false;
      });
    }
  }

  // PERBARUI: Navigasi ke HomeScreen jika sudah login
  void _navigateToHome(User user) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomeScreen(user: user),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  // PERBARUI: Navigasi ke LoginScreen
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F7FF), Color(0xFFE8F3FF), Color(0xFFF8FAFF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            _buildBackgroundElements(),

            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo Container dengan Vector.png
                      SlideTransition(
                        position: _slideAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF5B8DFF),
                                    const Color(0xFF0D6EFD),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF5B8DFF,
                                    ).withOpacity(0.4),
                                    blurRadius: 25,
                                    offset: const Offset(0, 15),
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    blurRadius: 30,
                                    offset: const Offset(-10, -10),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Hero(
                                  tag: 'app-logo',
                                  child: Image.asset(
                                    'assets/images/Vector.png',
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // App Name with multiple animations
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _bounceAnimation,
                            child: const Text(
                              'WargaKita',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0D6EFD),
                                letterSpacing: 2.0,
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black12,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Tagline dengan animasi
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          'Menghubungkan Ke Aplikasi Warga Kita',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // TAMBAHKAN: Status message untuk auth check
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          _statusMessage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Modern Animated Loading Indicator
                      _buildAdvancedLoadingIndicator(),

                      const SizedBox(height: 40),

                      // Animated Loading Text with Progressive Dots
                      _AnimatedLoadingText(
                        controller: _controller,
                        isCheckingAuth: _isCheckingAuth,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF5B8DFF).withOpacity(0.1),
              const Color(0xFF3366FF).withOpacity(0.05),
              Colors.transparent,
            ],
            stops: const [0.1, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedLoadingIndicator() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating circle
          RotationTransition(
            turns: _controller,
            child: CircularProgressIndicator(
              value: _controller.value,
              strokeWidth: 4,
              valueColor: _colorAnimation,
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),

          // Middle pulsing circle
          ScaleTransition(
            scale: _bounceAnimation,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.8), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3366FF).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Inner icon dengan kondisi auth check
          ScaleTransition(
            scale: _bounceAnimation,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isCheckingAuth
                    ? Colors.orange.shade600
                    : const Color(0xFF3366FF),
              ),
              child: Icon(
                _isCheckingAuth
                    ? Icons.security_rounded
                    : Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PERBARUI: _AnimatedLoadingText untuk support auth check
class _AnimatedLoadingText extends StatefulWidget {
  final AnimationController controller;
  final bool isCheckingAuth;

  const _AnimatedLoadingText({
    required this.controller,
    required this.isCheckingAuth,
  });

  @override
  State<_AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<_AnimatedLoadingText> {
  late Animation<int> _dotAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _dotAnimation = IntTween(begin: 0, end: 4).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_dotAnimation, _glowAnimation]),
      builder: (context, child) {
        String dots = '.' * _dotAnimation.value;
        String text = widget.isCheckingAuth
            ? 'Memeriksa sesi$dots'
            : 'Memuat$dots';

        return Opacity(
          opacity: _glowAnimation.value,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: widget.isCheckingAuth
                  ? Colors.orange.shade700
                  : const Color(0xFF666666),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// TAMBAHKAN: Simple Splash Screen untuk testing
class SimpleAuthSplashScreen extends StatelessWidget {
  const SimpleAuthSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      try {
        final isLoggedIn = await AuthService.isLoggedIn();
        final user = await AuthService.getUser();

        if (isLoggedIn && user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Vector.png',
              width: 100,
              height: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'WargaKita',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Memeriksa sesi login...',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Premium Splash Screen dengan Auth Check
class PremiumSplashWithAuth extends StatefulWidget {
  const PremiumSplashWithAuth({super.key});

  @override
  State<PremiumSplashWithAuth> createState() => _PremiumSplashWithAuthState();
}

class _PremiumSplashWithAuthState extends State<PremiumSplashWithAuth> {
  late String _status = 'Memulai aplikasi...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      setState(() => _status = 'Memuat konfigurasi...');
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() => _status = 'Memeriksa autentikasi...');
      await Future.delayed(const Duration(milliseconds: 500));

      final isLoggedIn = await AuthService.isLoggedIn();
      final user = await AuthService.getUser();

      if (isLoggedIn && user != null) {
        setState(() => _status = 'Login terdeteksi...');
        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen(user: user),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      } else {
        setState(() => _status = 'Mengarahkan ke login...');
        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } catch (e) {
      print('❌ Premium splash error: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0F7FF), Color(0xFFE3F2FD), Color(0xFFF8FAFF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'app-logo',
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B8DFF), Color(0xFF3366FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B8DFF).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Image.asset(
                      'assets/images/Vector.png',
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'WargaKita',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A237E),
                  letterSpacing: 1.8,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Komunitas Digital Modern',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 40),

              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3366FF).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF3366FF),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                _status,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
