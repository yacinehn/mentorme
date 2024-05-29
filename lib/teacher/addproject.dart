import 'package:flutter/material.dart';
import 'package:mentorme/teacher/functions.dart';
import 'package:mentorme/widgets.dart';

class AddProjectForm extends StatefulWidget {
  @override
  _AddProjectFormState createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _minPeoplesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _lvlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _minPeoplesController.dispose();
    _descriptionController.dispose();
    _lvlController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // Adjust width
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Adjust height
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter title',
                hintStyle: TextStyle(color: Colors.grey), // Hint text color
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _minPeoplesController,
              decoration: InputDecoration(
                labelText: 'Min Peoples',
                hintText: 'Enter minimum number of people',
                hintStyle: TextStyle(color: Colors.grey), // Hint text color
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the minimum number of people';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description',
                hintStyle: TextStyle(color: Colors.grey), // Hint text color
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _lvlController,
              decoration: InputDecoration(
                labelText: 'Level',
                hintText: 'Enter level',
                hintStyle: TextStyle(color: Colors.grey), // Hint text color
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a level';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var formData = {
                      'min peoples': _minPeoplesController.text,
                      'description': _descriptionController.text,
                      'lvl': _lvlController.text,
                      'title': _titleController.text,
                      'reserved': false
                    };
                    // Add your logic to save the project data
                    String uid = auth.currentUser!.uid;
                    addProject(uid, formData);
                    Navigator.pop(context); // Close the form
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
