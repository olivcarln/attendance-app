import 'package:attendance_app/screens/auth/widgets/auth_text_field.dart';
import 'package:attendance_app/screens/auth/widgets/gradient_scaffold.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterTap;

  const LoginScreen({super.key, required this.onRegisterTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthServices();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // trim supaya tidak ada spasi
    try {
      await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim()
      );
    } catch (e) {
      if (mounted) { 
        //kalo error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("an error occured, please try again later"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      logoIcon: Icons.calendar_month_rounded,
      title: 'Welcome Back',
      subtitle: 'Login to Continue',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      obscureText: false,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter your email' : null,
                    ),
                    SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon:  Icons.lock_outline,
                      obscureText: _obscurePassword,
                      // untuk visibility password
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.blue[600],
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword ),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter password' : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login_rounded, size: 20,),
                              SizedBox(width: 8),
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          )
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: widget.onRegisterTap,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white
            ),
            child: Text(
              "Don't have an account? Register"
            ),
          )
        ],
      ),
    );
  }
}