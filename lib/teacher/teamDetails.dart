import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mentorme/teacher/functions.dart';
import 'package:mentorme/widgets.dart';

class TeamDetails extends StatelessWidget {
  final String studentUid;
  final String projectid;
  TeamDetails({required this.studentUid, required this.projectid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(studentUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Student not found'));
          }

          var studentData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Contact: ${studentData['contact']}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Description: ${studentData['description']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Level: ${studentData['lvl']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Members:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                for (var member in studentData['members'].values)
                  Text(
                    '- $member',
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 10),
                Text(
                  'Skills: ${studentData['skills']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String uid = auth.currentUser!.uid;
                    await cancel(uid, projectid, studentUid);
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel Team'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
