import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../style/app_colors.dart';
import '../style/app_styles.dart';
import '../services/api_service.dart';
import '../utils/toast_helper.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare API call
        final url = Uri.parse('${ApiService.forgotPassword}');
        final body = json.encode({
          'email': _emailController.text.trim(),
        });

        // Make API call
        final response = await http.post(
          url,
          headers: ApiService.headers,
          body: body,
        );

        print('Forgot Password Response Status: ${response.statusCode}');
        print('Forgot Password Response Body: ${response.body}');

        // Handle response
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData['status'] == true) {
            // Show success toast
            ToastHelper.showSuccessTop(
              responseData['message'] ?? 'Password reset email sent successfully!'
            );

            // Navigate back to login screen using component
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          } else {
            // Show error message from API
            ToastHelper.showErrorTop(
              responseData['message'] ?? 'Failed to send reset email'
            );
          }
        } else {
          final responseData = json.decode(response.body);
          ToastHelper.showErrorTop(
            responseData['message'] ?? 'Failed to send reset email'
          );
        }
      } catch (e) {
        print('Forgot Password Error: $e');
        ToastHelper.showErrorTop('Network error. Please check your connection.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            fontFamily: AppStyles.fontFamily,
            fontSize: AppStyles.fontSize20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
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
                      Icons.lock_reset,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: AppStyles.spacing16),
                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: AppStyles.fontSize32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: AppStyles.spacing8),
                    Text(
                      'Enter your email address and we\'ll send you a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: AppStyles.fontSize16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Forgot Password Form
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

                    SizedBox(height: 50),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: AppStyles.buttonheight,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleForgotPassword,
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
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: AppColors.textOnPrimary,
                                strokeWidth: 2,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, size: 20),
                                  SizedBox(width: AppStyles.spacing8),
                                  Text('Send Reset Link',
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

                    // Back to Login
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                      child: Text('Back to Login'),
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