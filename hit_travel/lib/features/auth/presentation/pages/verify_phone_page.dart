import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:hit_travel/features/auth/presentation/widgets/auth_text_field.dart';
import 'dart:developer';

import 'package:hit_travel/core/network/dio_client.dart';
import 'package:hit_travel/features/profile/presentation/pages/profile_page.dart';

class VerifyPhonePage extends StatefulWidget {
  final String phoneNumber; // Номер телефона, на который ушло СМС

  const VerifyPhonePage({super.key, required this.phoneNumber});

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  final TextEditingController _codeController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // 1. Метод подтверждения кода
  Future<void> _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final requestData = {
        "phone": widget.phoneNumber,
        "code": int.tryParse(_codeController.text.trim()) ?? 0,
      };

      log("Verifying code: $requestData");

      try {
        final response = await _apiService.post('/auth/verify-phone', requestData);

        if (response.statusCode == 201 || response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Номер успешно подтвержден!'), backgroundColor: Colors.green),
            );
            // После подтверждения обычно отправляем на главную или страницу логина
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const ProfilePage(),
              ),
            );
          }
        }
      } on DioException catch (e) {
        _showError(e.response?.data?.toString() ?? "Ошибка верификации");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // 2. Метод повторной отправки кода
  Future<void> _resendCode() async {
    setState(() => _isLoading = true);

    // В Swagger указано, что phone должен быть integer для re-send?
    // Если сервер ждет число, уберем '+' и приведем к int.
    final cleanPhone = widget.phoneNumber.replaceAll('+', '');
    final requestData = {
      "phone": int.tryParse(cleanPhone) ?? 0,
    };

    try {
      final response = await _apiService.post('/auth/re-send', requestData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Код отправлен повторно'), backgroundColor: Colors.blue),
        );
      }
    } on DioException catch (e) {
      _showError(e.response?.data?.toString() ?? "Не удалось отправить код");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Подтверждение', style: TextStyle(color: Colors.white, fontSize: 17.sp)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Введите регистрационный код, высланный на номер ${widget.phoneNumber}',
                  style: TextStyle(fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 18),

                AuthTextField(
                  controller: _codeController,
                  hintText: 'Введите код',
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Введите код из СМС' : null,
                ),

                SizedBox(height: 22.h),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyCode,
                    style: AppTheme.elevatedButtonInAuth,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Подтвердить', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _resendCode,
                    child: const Text(
                      'Отправить снова',
                      style: TextStyle(color: Color(0xFF0671d2), fontSize: 15, fontWeight: FontWeight.w600),
                    ),
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