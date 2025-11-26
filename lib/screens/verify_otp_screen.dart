import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email, required Future<void> Function() onResendOtp});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isResending = false;
  int _countdown = 60;
  late Timer _timer;
  String? _lastOtpError;

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
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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

    // Clear error ketika user mulai mengetik lagi
    if (_lastOtpError != null) {
      setState(() {
        _lastOtpError = null;
      });
    }

    // Auto verify ketika semua field terisi
    if (_getOtpCode().length == 6) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final otpCode = _getOtpCode();

    print('🔢 OTP entered: $otpCode');
    print('📧 Email: ${widget.email}');

    if (otpCode.length != 6) {
      _showError('Harap masukkan 6 digit kode OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _lastOtpError = null;
    });

    try {
      print('🚀 Memulai verifikasi OTP dengan server...');

      // Panggil service untuk verifikasi OTP
      final authResponse = await _authService.verifyOtp(widget.email, otpCode);

      print('✅ Verifikasi OTP berhasil di server');
      print('📝 Message: ${authResponse.message}');
      print('👤 User: ${authResponse.user?.email}');
      print('🔑 Token: ${authResponse.accessToken != null ? '✓' : '✗'}');

      if (authResponse.user != null) {
        _showSuccess('Verifikasi berhasil! Mengarahkan ke Home Screen...');

        // Tunggu sebentar biar user bisa baca pesan sukses
        await Future.delayed(const Duration(milliseconds: 1500));

        // Navigate ke HomeScreen
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: authResponse.user!),
            ),
            (route) => false,
          );
        }
      } else {
        throw Exception('Data user tidak ditemukan dalam response');
      }
    } catch (e) {
      print('❌ OTP verification error: $e');
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _lastOtpError = errorMessage;
      });
      _showError(errorMessage);
      _shakeOtpFields();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _shakeOtpFields() {
    // Effect visual untuk menunjukkan error
    setState(() {});
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);

    try {
      print('🔄 Mengirim ulang OTP ke: ${widget.email}');

      await _authService.resendOtp(widget.email);

      _showSuccess('Kode OTP baru telah dikirim ke ${widget.email}');

      setState(() {
        _countdown = 60;
        _lastOtpError = null;
      });
      _startTimer();
      _clearOtpFields();
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showError('Gagal mengirim ulang OTP: $errorMessage');
    } finally {
      setState(() => _isResending = false);
    }
  }

  void _clearOtpFields() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() {
      _lastOtpError = null;
    });
    print('🧹 OTP fields cleared');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: _goBack,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Verifikasi OTP',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header dengan icon
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: Colors.blue.shade600,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Verifikasi OTP',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Masukkan 6 digit kode OTP yang dikirim ke',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Error message jika ada
              if (_lastOtpError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _lastOtpError!,
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // OTP Input Fields
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final hasError = _lastOtpError != null;
                    return Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hasError
                                  ? Colors.red.shade300
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hasError ? Colors.red : Colors.blue,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: hasError
                                  ? Colors.red.shade300
                                  : Colors.grey.shade300,
                            ),
                          ),
                          filled: true,
                          fillColor: hasError
                              ? Colors.red.shade50
                              : Colors.white,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: hasError ? Colors.red.shade800 : Colors.black,
                        ),
                        onChanged: (value) => _handleOtpChange(value, index),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // Info bahwa OTP dikirim via email
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kode OTP telah dikirim ke email Anda. Periksa folder spam jika tidak ditemukan.',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Countdown Timer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _countdown < 10
                      ? Colors.orange.shade50
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _countdown < 10
                        ? Colors.orange.shade100
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: _countdown < 10
                          ? Colors.orange
                          : Colors.grey.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kode OTP kadaluarsa dalam: $_countdown detik',
                      style: TextStyle(
                        color: _countdown < 10
                            ? Colors.orange
                            : Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Resend OTP Button
              Center(
                child: _isResending
                    ? const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text(
                            'Mengirim ulang OTP...',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: _countdown == 0 ? _resendOtp : null,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              color: _countdown == 0
                                  ? Colors.blue
                                  : Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Kirim ulang OTP',
                              style: TextStyle(
                                color: _countdown == 0
                                    ? Colors.blue
                                    : Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 40),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.blue.withOpacity(0.3),
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
                            Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Verifikasi OTP',
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

              const SizedBox(height: 16),

              // Clear OTP Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _clearOtpFields,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.clear_all_rounded,
                        color: Colors.grey,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Hapus Kode',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
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
