import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:hit_travel/core/network/dio_client.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:hit_travel/features/auth/presentation/pages/login_page.dart';
import 'package:hit_travel/features/auth/presentation/pages/verify_phone_page.dart';
import 'package:hit_travel/features/auth/presentation/widgets/auth_text_field.dart';
import 'dart:developer';

import 'package:hit_travel/features/auth/data/models/register_request.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final request = RegisterRequest(
        email: _emailController.text.trim(),
        phone: "+996${_phoneController.text.trim()}",
        firstName: _nameController.text.trim(),
        lastName: _surnameController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      log("Sending to API: ${request.toJson()}");


      try {
        final response = await _apiService.register(request.toJson());

        if (response.statusCode == 201 || response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Осталось немного, подтвердите пожалуйста номер телефона'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
            final phone = "+996${_phoneController.text.trim()}";
            serviceLocator<Talker>().info("Phone: $phone");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyPhonePage(phoneNumber: phone),
              ),
            );
          }
        }
      } on DioException catch (e) {
        serviceLocator<Talker>().handle(e, null, "[RegistrationPageError] _register() method");
        String errorMessage = "Произошла ошибка";

        if (e.response?.data != null && e.response?.data is Map) {
          errorMessage = e.response?.data.toString() ?? errorMessage;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Непредвиденная ошибка: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
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
        title: const Text(
          'Регистрация',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildLabel('Имя'),
                AuthTextField(
                  controller: _nameController,
                  hintText: 'Имя',
                  validator: (v) => v!.isEmpty ? 'Введите имя' : null,
                ),
                const SizedBox(height: 12),

                _buildLabel('Фамилия'),
                AuthTextField(
                  controller: _surnameController,
                  hintText: 'Фамилия',
                  validator: (v) => v!.isEmpty ? 'Введите фамилию' : null,
                ),
                const SizedBox(height: 12),

                _buildLabel('Номер телефона'),
                _buildPhoneField(),
                const SizedBox(height: 12),

                _buildLabel('E-mail'),
                AuthTextField(
                  controller: _emailController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Некорректный email'
                      : null,
                ),
                const SizedBox(height: 12),

                _buildLabel('Пароль'),
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Пароль',
                  isPassword: true,
                  validator: (v) => v!.length < 4 ? 'Минимум 4 символов' : null,
                ),
                const SizedBox(height: 12),

                _buildLabel('Повторите пароль'),
                AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Повторите пароль',
                  isPassword: true,
                  validator: (v) => v != _passwordController.text
                      ? 'Пароли не совпадают'
                      : null,
                ),
                const SizedBox(height: 20),

                _buildTermsText(),
                const SizedBox(height: 20),

                // registration button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: AppTheme.elevatedButtonInAuth,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Регистрация',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLoginLink(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // helper widgets
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: AppTheme.labelText),
  );

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text('🇰🇬', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                const Text(
                  '+996',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Введите номер' : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14.sp, color: Colors.black54, height: 1.3),
        children: const [
          TextSpan(
            text: 'Нажимая на кнопку «Регистрация», Вы принимаете условия ',
          ),
          TextSpan(
            text: 'Публичной оферты',
            style: TextStyle(
              color: Color(0xFF0066CC),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Уже есть аккаунт? ', style: TextStyle(fontSize: 16)),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text(
            'Войти',
            style: TextStyle(
              color: Color(0xFF0066CC),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
