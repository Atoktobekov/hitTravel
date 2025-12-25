import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:hit_travel/features/auth/presentation/pages/login_page.dart';
import 'package:hit_travel/features/auth/presentation/widgets/auth_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.blueColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Вход в профиль',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Label
              Text('Имя', style: AppTheme.labelText),
              const SizedBox(height: 8),
              // Name TextField
              AuthTextField(
                controller: _nameController,
                hintText: 'Имя',
              ),

              const SizedBox(height: 12),

              // Surname Label
              const Text(
                'Фамилия',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              // Surname TextField
              AuthTextField(
                controller: _surnameController,
                hintText: 'Фамилия',
              ),

              const SizedBox(height: 12),

              // Phone Label
              Text('Номер телефона', style: AppTheme.labelText),
              const SizedBox(height: 8),

              // Phone TextField with Flag
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 22,
                            child: const Center(
                              child: Text(
                                '🇰🇬',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '+996',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Email Label
              Text('E-mail', style: AppTheme.labelText),
              const SizedBox(height: 8),

              // Email TextField
              AuthTextField(
                controller: _emailController,
                hintText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              // Password Label
              Text('Пароль', style: AppTheme.labelText),
              const SizedBox(height: 8),

              // Password TextField
              AuthTextField(
                controller: _passwordController,
                hintText: 'Пароль',
                isPassword: true,
              ),

              const SizedBox(height: 12),

              // Confirm Password Label
              Text('Повторите пароль', style: AppTheme.labelText),
              const SizedBox(height: 8),

              // Confirm Password TextField
              AuthTextField(
                controller: _confirmPasswordController,
                hintText: 'Повторите пароль',
                isPassword: true,
              ),

              const SizedBox(height: 12),

              // Terms Text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black.withAlpha(200),
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Нажимая на кнопку «Регистрация», Вы принимаете условия ',
                    ),
                    TextSpan(
                      text: 'Публичной оферты',
                      style: TextStyle(
                        color: Color(0xFF0066CC),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Registration Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO Handle registration
                  },
                  style: AppTheme.elevatedButtonInAuth,
                  child: Text(
                    'Регистрация',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Уже есть аккаунт? ',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
