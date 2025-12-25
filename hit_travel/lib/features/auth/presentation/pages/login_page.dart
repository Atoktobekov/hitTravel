import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:hit_travel/features/auth/presentation/pages/register_page.dart';
import 'package:hit_travel/features/auth/presentation/widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          padding: EdgeInsets.only(left: 10.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Войти',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // E-mail Label
              Text(
                'E-mail',
                style: AppTheme.labelText,
              ),
              const SizedBox(height: 8),

              // E-mail TextField
              AuthTextField(
                controller: _emailController,
                hintText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              // Password Label
              Text(
                'Пароль',
                style: AppTheme.labelText,
              ),
              const SizedBox(height: 8),

              // Password TextField
              AuthTextField(
                controller: _passwordController,
                hintText: 'Пароль',
                isPassword: true,
              ),

              const SizedBox(height: 16),

              // Forgot Password Link
              GestureDetector(
                onTap: () {
                  // Handle forgot password
                },
                child: const Text(
                  'Забыли пароль?',
                  style: TextStyle(
                    color: Color(0xFF0671d2),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO Handle login
                  },
                  style: AppTheme.elevatedButtonInAuth,
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ещё нет аккаунта? ',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO Handle sign up
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const RegistrationPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Зарегистрироваться',
                      style: TextStyle(
                        color: Color(0xFF0671d2),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
