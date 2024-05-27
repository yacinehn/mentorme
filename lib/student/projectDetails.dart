import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:mentorme/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectDetails extends StatefulWidget {
  final String docId;

  const ProjectDetails({Key? key, required this.docId}) : super(key: key);

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendRequest(String title, pid) async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot studentDoc =
          await _firestore.collection('students').doc(uid).get();

      if (!studentDoc.exists) {
        throw 'Student document not found';
      }

      Map<String, dynamic> studentData =
          studentDoc.data() as Map<String, dynamic>;
      String description = studentData['description'] ?? 'No description';
      Map<String, String> members =
          Map<String, String>.from(studentData['members'] ?? {});
      String skills = studentData['skills'] ?? 'No skills';
      String level = studentData['lvl'] ?? 'No level';
      String contact = studentData['contact'];

      Map<String, dynamic> requestData = {
        'description': description,
        'members': members,
        'skills': skills,
        'level': level,
        'studentUid': uid,
        'applied project ': title,
        'docid': pid,
        'contact': contact
      };

      await _firestore
          .collection('teachers')
          .doc(widget.docId)
          .collection('requests')
          .add(requestData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('teachers')
            .doc(widget.docId)
            .collection('projects')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No projects found'));
          }

          var projects = snapshot.data!.docs;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              var project = projects[index];
              var title = project['title'] ?? 'No title';
              var description = project['description'] ?? 'No description';
              var minPeople = project['min peoples'] ?? 0;
              var docid = project.id;

              return Card(
                margin: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center horizontally
                    // Center vertically if needed
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center, // Center the text
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center, // Center the text
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Minimum People Required: $minPeople',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center, // Center the text
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          sendRequest(title, docid);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Text color
                        ),
                        child: const Text('Send Request'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
