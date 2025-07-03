import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:packwork/pages/forgetpassword_screen.dart';
import 'package:packwork/utils/toast_helper.dart';
import 'dart:convert';
import '../style/app_colors.dart';
import '../style/app_styles.dart';
import '../services/api_service.dart';
import '../utils/preferences_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare API call
        final url = Uri.parse('${ApiService.baseUrl}/user/employee/login');
        final body = json.encode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        });

        // Make API call
        final response = await http.post(
          url,
          headers: ApiService.loginheaders,
          body: body,
        );

        print('Login Response Status: ${response.statusCode}');
        print('Login Response Body: ${response.body}');

        // Handle response
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData['status'] == true &&
              responseData['message'] == 'Login successful') {
            // Store only token using PreferencesHelper
            await PreferencesHelper.setAuthToken(responseData['token']);

            // Show success toast
            ToastHelper.showSuccessTop('Login successful!');

            // Navigate to home screen
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          final responseData = json.decode(response.body);
          // Show error message from API
          print('Login Error New: ${responseData['message']}');
          ToastHelper.showErrorTop(
            responseData['message'] ?? 'Login failed',
          );
        }
      } catch (e) {
        print('Login Error: $e');
        ToastHelper.showErrorTop('${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //  For got Password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Logo or Title
              Container(
                padding: const EdgeInsets.all(AppStyles.spacing20),
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: AppStyles.spacing16),
                    Text(
                      'PACKWORKS',
                      style: TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: AppStyles.fontSize32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: AppStyles.spacing8),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppStyles.inputText.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: AppStyles.inputLabel.copyWith(
                          color: AppColors.textPrimary,
                          fontFamily: AppStyles.fontFamily,
                        ),
                        hintText: 'Enter your email address',
                        hintStyle: AppStyles.inputText.copyWith(
                          color: AppColors.textHint,
                          fontFamily: AppStyles.fontFamily,
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide: BorderSide(color: AppColors.inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide: BorderSide(color: AppColors.inputBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide:
                              BorderSide(color: AppColors.inputFocus, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide: BorderSide(color: AppColors.error),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppStyles.spacing16,
                          vertical: AppStyles.spacing18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppStyles.spacing16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppStyles.inputText.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: AppStyles.inputLabel.copyWith(
                          color: AppColors.textPrimary,
                          fontFamily: AppStyles.fontFamily,
                        ),
                        hintText: 'Enter your password',
                        hintStyle: AppStyles.inputText.copyWith(
                          color: AppColors.textHint,
                          fontFamily: AppStyles.fontFamily,
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide: BorderSide(color: AppColors.inputBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide: BorderSide(color: AppColors.inputBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide:
                              BorderSide(color: AppColors.inputFocus, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppStyles.borderRadiusMedium),
                          borderSide: BorderSide(color: AppColors.error),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppStyles.spacing16,
                          vertical: AppStyles.spacing18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 50),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: AppStyles.buttonheight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          foregroundColor: AppColors.textOnPrimary,
                          textStyle: TextStyle(
                            fontSize: AppStyles.buttonFontSize,
                            fontWeight: AppStyles.buttonWeight,
                            fontFamily: AppStyles.fontFamily,
                            color: AppStyles.buttonColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppStyles.buttonRadius),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, size: 20),
                            SizedBox(width: AppStyles.spacing8),
                            Text('Login',
                                style: TextStyle(
                                  fontFamily: AppStyles.fontFamily,
                                  fontSize: AppStyles.buttonFontSize,
                                  fontWeight: AppStyles.buttonWeight,
                                  color: AppStyles.buttonColor,
                                )),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppStyles.spacing16),

                    // Forgot Password
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                        // Handle forgot password
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: TextStyle(
                          fontFamily: AppStyles.fontFamily,
                          fontSize: AppStyles.forgotfontszie,
                          fontWeight: AppStyles.buttonWeight,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppStyles.spacing16,
                          vertical: AppStyles.spacing8,
                        ),
                      ),
                      child: Text('Forgot Password?'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
