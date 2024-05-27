import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorme/auth/SignUpPage.dart';
import 'package:mentorme/auth/SingTeacher.dart';
import 'package:mentorme/auth/SkillsOfEtudiant.dart';

class SignUpPage2 extends StatefulWidget {
  final String title;

  SignUpPage2({Key? key, required this.title}) : super(key: key);
  @override
  State<SignUpPage2> createState() => _SignUpPage2();
}

class _SignUpPage2 extends State<SignUpPage2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 245, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: _togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Confirm your password',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: _togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your email address.'),
                    ),
                  );
                  return;
                }
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match!'),
                    ),
                  );
                  return;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 84, 255, 127),
                textStyle: const TextStyle(color: Colors.black),
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
