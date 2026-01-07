import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/network/auth_cache_manager.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:hit_travel/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:hit_travel/core/network/dio_client.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await _apiService.changePassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Пароль успешно изменен'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } on DioException catch (e) {
        serviceLocator<Talker>().handle(e, null, "[ChangePassword] Error");
        String errorMsg = "Ошибка при смене пароля";

        if (e.response?.data != null && e.response?.data is Map) {
          // Бэк может вернуть ошибки по конкретным полям
          final data = e.response?.data;
          errorMsg = data['detail'] ?? data['message'] ?? data['old_password']?[0] ?? errorMsg;
        }
        _showError(errorMsg);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
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
        title: Text('Изменить пароль',
            style: TextStyle(color: Colors.white, fontSize: 17.sp)),
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
                const SizedBox(height: 16),

                _buildLabel('Старый пароль'),
                AuthTextField(
                  controller: _oldPasswordController,
                  hintText: 'Cтарый пароль',
                  isPassword: true,
                  validator: (v) => v!.isEmpty ? 'Введите старый пароль' : null,
                ),

                const SizedBox(height: 15),

                _buildLabel('Новый пароль'),
                AuthTextField(
                  controller: _newPasswordController,
                  hintText: 'Новый пароль',
                  isPassword: true,
                  validator: (v) => v!.length < 8 ? 'Минимум 8 символов' : null,
                ),

                const SizedBox(height: 15),

                _buildLabel('Повторите пароль'),
                AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Повторите пароль',
                  isPassword: true,
                  validator: (v) {
                    if (v != _newPasswordController.text) return 'Пароли не совпадают';
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: AppTheme.elevatedButtonInAuth,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Изменить',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTheme.labelText),
    );
  }
}