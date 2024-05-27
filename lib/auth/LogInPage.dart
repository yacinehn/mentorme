import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentorme/auth/SignUpPage.dart';
import 'package:mentorme/auth/auth_state.dart';

import 'package:mentorme/student/HomePageS.dart';
import 'package:mentorme/teacher/HomePageT.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPgeState();
}

class _LoginPgeState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 226, 245, 255), // Example color

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mentor Me',
              style: TextStyle(
                fontSize: 40.0, // Adjust font size as needed
                fontWeight: FontWeight.bold, // Make the text bold (optional)
                color: Color.fromARGB(
                    255, 0, 0, 0), // Adjust color based on background
              ),
            ),
            const SizedBox(height: 40.0), // Spacing between fields
            SizedBox(
              width: 300.0, // Adjust width as needed
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color:
                        Colors.grey.withOpacity(0.3), // Optional for faint hint
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Spacing between fields

            SizedBox(
              width: 300.0, // Adjust width as needed
              child: TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(
                    color:
                        Colors.grey.withOpacity(0.3), // Optional for faint hint
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: _togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  errorText: _errorMessage?.isNotEmpty == true
                      ? _errorMessage
                      : null, // Set error text if available
                  errorStyle: const TextStyle(
                    color: Colors.red, // Set error text color to red
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            _isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromRGBO(84, 255, 127, 1), // Green color
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        await Provider.of<AuthState>(context, listen: false)
                            .signIn(_emailController.text,
                                _passwordController.text);
                      } catch (e) {
                        setState(() {
                          _errorMessage = e.toString();
                        });
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(84, 255, 127, 1),
                      textStyle: const TextStyle(color: Colors.black),
                    ),
                    child: const Text('Login'),
                  ),

            const SizedBox(height: 20.0),

            const Text('Don\'t have an account?'),
            const SizedBox(width: 10.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Adjust text color as needed
              ),
              child: const Text('Sign Up'),
            ),

            const SizedBox(height: 50.0), // Spacing between text and button
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Adjust text color as needed
              ),
              child: const Text('I forgot my password'),
            ),
          ],
        ),
      ),
    );
  }
}
