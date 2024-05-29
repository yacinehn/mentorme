import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorme/auth/auth_state.dart';
import 'package:mentorme/student/projectDetails.dart';
import 'package:mentorme/widgets.dart';
import 'package:provider/provider.dart';

// Adjust the path according to your project structure

class HomePageS extends StatefulWidget {
  @override
  State<HomePageS> createState() => _HomePageS();
}

class _HomePageS extends State<HomePageS> {
  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Available Teachers'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(84, 255, 127, 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Mentor Me',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await Provider.of<AuthState>(context, listen: false).signOut();
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 226, 245, 255),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('students').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          bool reserved = userData['reserved'] ?? false;
          String teacherUid = userData['teacherUid'] ?? '';

          if (reserved && teacherUid.isNotEmpty) {
            // User has reserved a teacher, display details of the reserved teacher
            return StreamBuilder<DocumentSnapshot>(
              stream:
                  firestore.collection('teachers').doc(teacherUid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Teacher not found'));
                }
                var teacherData = snapshot.data!.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact: ${teacherData['contact'] ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description: ${teacherData['description'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Name: ${teacherData['name'] ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red, // Text color
                        ),
                        child: const Text('cancel the Mentor'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            // User has not reserved a teacher, display available teachers
            return StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('teachers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No teachers found'));
                }

                var teachers = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    var teacher = teachers[index];
                    var name = teacher['name'] ?? 'No name';
                    var description =
                        teacher['description'] ?? 'No description';
                    var docid = teacher.id;

                    return Card(
                      margin: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectDetails(docId: docid),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue, // Text color
                              ),
                              child: const Text('See Projects'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
