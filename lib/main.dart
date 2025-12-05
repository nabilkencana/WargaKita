import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_latihan1/screens/splash_screen.dart';
import 'package:flutter_latihan1/screens/login_screen.dart';
import 'package:flutter_latihan1/screens/home_screen.dart';
import 'package:flutter_latihan1/screens/verify_otp_screen.dart';
import 'package:flutter_latihan1/models/user_model.dart';
import 'package:flutter_latihan1/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  print('🚀 Starting WargaKita app...');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      print('🔍 Checking authentication status...');

      final isLoggedIn = await AuthService.isLoggedIn();
      final user = await AuthService.getUser();

      print('   Is logged in: $isLoggedIn');
      print('   User email: ${user?.email}');
      print('   User ID: ${user?.id}');

      setState(() {
        _isLoggedIn = isLoggedIn;
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error checking auth status: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.blue.shade50,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'Menyiapkan aplikasi...',
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'WargaKita',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        scaffoldBackgroundColor: Colors.white,
        // ✅ PERBAIKAN: Gunakan CardThemeData bukan CardTheme
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        // ✅ TAMBAHKAN: Color scheme untuk konsistensi
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,

      // HOME ROUTE
      home: _isLoggedIn && _currentUser != null
          ? HomeScreen(user: _currentUser!)
          : const SplashToLoginScreen(),

      // NAMED ROUTES
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) {
          if (_currentUser != null) {
            return HomeScreen(user: _currentUser!);
          }
          return const LoginScreen();
        },
        '/splash': (context) => const SplashToLoginScreen(),
      },

      // ON GENERATE ROUTE
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/verify-otp':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => VerifyOtpScreen(
                email: args['email'],
                onResendOtp: args['onResendOtp'],
              ),
            );

          case '/profile':
            final user = settings.arguments as User;
            return MaterialPageRoute(
              builder: (context) => HomeScreen(user: user),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => const SplashToLoginScreen(),
            );
        }
      },

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
