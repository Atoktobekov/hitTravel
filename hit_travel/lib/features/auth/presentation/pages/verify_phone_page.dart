import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:hit_travel/features/auth/presentation/pages/authorized_profile_page.dart';
import 'package:hit_travel/features/auth/presentation/widgets/auth_text_field.dart';

import 'package:hit_travel/core/network/dio_client.dart';
import 'package:talker_flutter/talker_flutter.dart';

class VerifyPhonePage extends StatefulWidget {
  final String phoneNumber;

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

  Future<void> _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final requestData = {
        "phone": widget.phoneNumber,
        "code": int.tryParse(_codeController.text.trim()) ?? 0,
      };

      try {
        final response = await _apiService.post('/auth/verify-phone', requestData);

        final bool isSuccess = response.data['response'] == true;
        final String message = response.data['message'] ?? "";

        if (isSuccess) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Номер успешно подтвержден!'), backgroundColor: Colors.green),
            );

            // // TODO handle successful sign-up
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthorizedProfilePage()),
                  (route) => false,
            );
          }
        } else {
          _showError(message.isNotEmpty ? message : "Введен неверный код");
        }
      } on DioException catch (e) {
        _showError(e.response?.data?['message']?.toString() ?? "Ошибка верификации");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);

    final requestData = {

      "phone": widget.phoneNumber,
    };

    serviceLocator<Talker>().info("Resending code to: $requestData");

    try {
      final response = await _apiService.post('/auth/re-send', requestData);

      final bool isSuccess = response.data['response'] == true;

      if (isSuccess || response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Код отправлен повторно'), backgroundColor: Colors.blue),
          );
        }
      } else {
        _showError(response.data['message'] ?? "Ошибка отправки");
      }
    } on DioException catch (e) {
      _showError(e.response?.data?['message']?.toString() ?? "Не удалось отправить код");
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
        title: Text('Вход в профиль', style: TextStyle(color: Colors.white, fontSize: 17.sp)),
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
                Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w), child: Text(
                  'Введите регистрационный код, высланный на указанный номер телефона',
                  style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),),
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