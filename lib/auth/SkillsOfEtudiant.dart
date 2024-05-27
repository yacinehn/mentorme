import 'package:flutter/material.dart';
import 'package:mentorme/auth/SignUpPage2.dart';
import 'package:mentorme/auth/LogInPage.dart';

class SkillsOfEtudiant extends StatefulWidget {
  SkillsOfEtudiant({
    Key? key,
    required Map<String, String> userData,
  }) : super(key: key);

  @override
  State<SkillsOfEtudiant> createState() => _SkillsOfEtudiantState();
}

class _SkillsOfEtudiantState extends State<SkillsOfEtudiant> {
  final _formKey = GlobalKey<FormState>();
  String _team = '';
  String _skills = '';
  String _note = '';
  String _gradeLevel = '';
  List<Project> _projects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 245, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Project form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 300.0,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Team',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter the team' : null,
                        onSaved: (value) => setState(() => _team = value!),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 300.0,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Skills',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter Skills' : null,
                        onSaved: (value) => setState(() => _skills = value!),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 300.0,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Note',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a note' : null,
                        onSaved: (value) => setState(() => _note = value!),
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('License'),
                      value: 'License',
                      groupValue: _gradeLevel,
                      onChanged: (value) =>
                          setState(() => _gradeLevel = value!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Master'),
                      value: 'Master',
                      groupValue: _gradeLevel,
                      onChanged: (value) =>
                          setState(() => _gradeLevel = value!),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // Add project to the list
                          final project = Project(
                            team: _team,
                            skills: _skills,
                            note: _note,
                            gradeLevel: _gradeLevel,
                          );
                          //setState(() => _projects.add(project));

                          // Clear form fields
                          _formKey.currentState!.reset();
                          _team = '';
                          _skills = '';
                          _note = '';
                          _gradeLevel = '';
                        }
                      },
                      child: const Text('add Project'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 84, 255, 127),
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              // added projects list
              if (_projects.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    final project = _projects[index];
                    return Dismissible(
                      // Use Dismissible for swipe deletion
                      key:
                          ValueKey(project.team), // Unique key for each project
                      confirmDismiss: (direction) => showDialog(
                        // Confirmation dialog
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text(
                              'Are you sure you want to delete "${project.team}"?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false), // Cancel
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true), // Delete
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          setState(() {
                            _projects
                                .removeAt(index); // Remove project on deletion
                          });
                        }
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(project.team),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Skills: ${project.skills}'),
                              Text('Description: ${project.note}'),
                              Text('Level: ${project.gradeLevel}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  final snackBar = const SnackBar(
                    content: Text('Signing up...'),
                    duration: Duration(seconds: 5),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text('Sing Up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 255, 127),
                  textStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Project {
  final String team;
  final String skills;
  final String note;
  final String gradeLevel;

  const Project({
    required this.team,
    required this.skills,
    required this.note,
    required this.gradeLevel,
  });
}
