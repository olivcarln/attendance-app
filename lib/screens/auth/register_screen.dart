import 'package:attendance_app/screens/widgets/auth_text_field.dart';
import 'package:attendance_app/screens/widgets/gradient_scaffold.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginTap;
  const RegisterScreen({super.key, required this.onLoginTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService =AuthServices();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim()
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red)
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      logoIcon: Icons.person_add_rounded,
      title: 'Create Account',
      subtitle: 'Register to get started',
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
                    icon: Icons.email_outlined, 
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator:(value) =>
                        value?.isEmpty ?? true ? "Please enter your email" : null,
                    ), SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.blue[600],
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword)
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'please enter your password';
                          if (value!.length < 6)return 'password must be at least 6 character'; 
                          return null;
                        },
                    ),
                    SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.blue[600],
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword =! _obscurePassword ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true)return 'please confirm your password';
                        if (value != _passwordController.text)return 'Password do not match'; 
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
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
                            width:20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
           onPressed: widget.onLoginTap,
           style: TextButton.styleFrom(foregroundColor: Colors.white),
           child: Text(
            'Already have an account? Login',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
           ),
           ),
          
        ],
      ),
    );
  }
}
