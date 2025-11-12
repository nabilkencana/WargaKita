import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'home_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _countdown = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    print('🔄 VerifyOtpScreen initialized for email: ${widget.email}');
    _startTimer();
    _setupOtpFields();
    _showInitialSuccess();
  }

  void _showInitialSuccess() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode OTP telah dikirim ke ${widget.email}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  void _setupOtpFields() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _otpControllers[i].text.isEmpty) {
          if (i > 0) _focusNodes[i - 1].requestFocus();
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _handleOtpChange(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  // 🔥 MODIFIED: Langsung navigate ke HomeScreen tanpa validasi OTP
  Future<void> _verifyOtp() async {
    final otpCode = _getOtpCode();

    print('🔢 OTP entered: $otpCode');
    print('🎯 LANGSUNG NAVIGATE KE HOME SCREEN!');

    setState(() => _isLoading = true);

    try {
      // Tampilkan loading sebentar
      await Future.delayed(const Duration(milliseconds: 500));

      // Buat user data dummy
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: widget.email,
        name: 'Budi Styawan', // Nama dari data register
        role: 'user',
      );

      print('✅ Auto-verification successful!');
      print('👤 User: ${user.email}');
      print('🚀 Navigating to HomeScreen...');

      // Tampilkan notifikasi sukses
      _showSuccess('Login berhasil! Mengarahkan ke Home Screen...');

      // Tunggu sebentar biar user bisa baca pesan
      await Future.delayed(const Duration(milliseconds: 1000));

      // 🔥 LANGSUNG NAVIGATE KE HOME SCREEN
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
          (route) => false,
        );
      }
    } catch (e) {
      print('❌ Navigation error: $e');
      _showError('Gagal mengarahkan ke halaman utama: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔥 MODIFIED: Resend OTP juga langsung navigate (untuk testing)
  Future<void> _resendOtp() async {
    setState(() => _isResending = true);

    try {
      print('🔄 Resending OTP...');

      // Simulasi proses resend
      await Future.delayed(const Duration(seconds: 1));

      _showSuccess('Kode OTP baru telah dikirim');

      setState(() => _countdown = 60);
      _startTimer();
      _clearOtpFields();
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isResending = false);
    }
  }

  void _clearOtpFields() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    print('🧹 OTP fields cleared');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _goBack() {
    print('🔙 Going back to login screen');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer.cancel();
    print('🧹 VerifyOtpScreen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Verifikasi OTP',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Info - MODIFIED: Tambahkan info bahwa ini auto-navigate
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'DEMO MODE: Langsung ke HomeScreen',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Masukkan 6 digit kode OTP',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 8),

              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 40),

              // OTP Input Fields
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        onChanged: (value) => _handleOtpChange(value, index),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // Countdown Timer
              Center(
                child: Text(
                  'Kode OTP kadaluarsa dalam: $_countdown detik',
                  style: TextStyle(
                    color: _countdown < 10 ? Colors.red : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Resend OTP Button
              Center(
                child: _isResending
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: _countdown == 0 ? _resendOtp : null,
                        child: Text(
                          'Kirim ulang OTP',
                          style: TextStyle(
                            color: _countdown == 0 ? Colors.blue : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 40),

              // 🔥 MODIFIED: Tombol langsung navigate
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Ubah warna jadi hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Langsung ke HomeScreen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // Tombol alternatif untuk testing
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text(
                    'Test Navigate (Tanpa OTP)',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
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
