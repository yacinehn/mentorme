import 'package:flutter/material.dart';
import 'package:mentorme/auth/SingTeacher.dart';
import 'package:mentorme/auth/SkillsOfEtudiant.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String? _selectedGender;
  String? _selectedRole;

  void _showGenderSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Male';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'Female';
                  });
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  } //fin gender void

  void _showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Teacher'),
                onTap: () {
                  setState(() {
                    _selectedRole = 'Teacher';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Student'),
                onTap: () {
                  setState(() {
                    _selectedRole = 'Student';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
              width: 300.0, // Adjust width as needed
              child: TextField(
                controller: firstNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Enter your first Name ',
                  hintStyle: TextStyle(
                    color:
                        Colors.grey.withOpacity(0.3), // Optional for faint hint
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              // ... other properties
            ),

            const SizedBox(height: 20.0), // Spacing between fields

            SizedBox(
              width: 300.0, // Adjust width as needed
              child: TextField(
                controller: lastNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Enter your lastt Name ',
                  hintStyle: TextStyle(
                    color:
                        Colors.grey.withOpacity(0.3), // Optional for faint hint
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              // ... other properties
            ),

            //gender
            SizedBox(
              width: 300.0,
              child: TextField(
                readOnly: true, // Disable manual text input
                decoration: InputDecoration(
                  hintText: _selectedGender != null
                      ? _selectedGender
                      : 'Select Gender',
                  hintStyle: TextStyle(
                    color:
                        Colors.grey.withOpacity(0.3), // Optional for faint hint
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons
                        .arrow_drop_down), // Down arrow for dropdown appearance
                    onPressed: () {
                      _showGenderSelectionDialog(context);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            SizedBox(
              width: 300.0,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText:
                      _selectedRole != null ? _selectedRole : 'Select role',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      _showRoleSelectionDialog(context);
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0), // Spacing between fields
            ElevatedButton(
              onPressed: () {
                // Validate firstname

                if (firstNameController.text.isEmpty ||
                    lastNameController.text.isEmpty ||
                    _selectedGender == null ||
                    _selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter all your fields'),
                    ),
                  );
                  return;
                }
                Map<String, String> userData = {
                  'firstName': firstNameController.text,
                  'lastName': lastNameController.text,
                  'gender': _selectedGender!,
                  'role': _selectedRole!,
                };
                if (_selectedRole == 'student') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SkillsOfEtudiant(userData: userData)),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingTeacher(userData: userData)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 84, 255, 127),
                textStyle: const TextStyle(color: Colors.black),
              ),
              // Handle Sign Up press (navigation to signup page2)
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
