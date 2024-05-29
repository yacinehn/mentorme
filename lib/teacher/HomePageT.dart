import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorme/auth/auth_state.dart';
import 'package:mentorme/teacher/addproject.dart';
import 'package:mentorme/teacher/functions.dart';
import 'package:mentorme/teacher/teamDetails.dart';
import 'package:mentorme/widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageT extends StatefulWidget {
  HomePageT({Key? key}) : super(key: key);

  @override
  State<HomePageT> createState() => _HomePageTState();
}

class _HomePageTState extends State<HomePageT> {
  late String uid;
  String selectedCollection = 'requests'; // 'requests' or 'projects'

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 245, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(''),
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCollection = 'requests';
                  });
                },
                child: const Text('Requests'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCollection = 'projects';
                  });
                },
                child: const Text('Projects'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('teachers')
                  .doc(uid)
                  .collection(selectedCollection)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No request found'));
                }

                var items = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index].data() as Map<String, dynamic>;
                    var itemId = items[index].id;

                    if (selectedCollection == 'requests') {
                      return buildRequestCard(item, itemId);
                    } else {
                      return buildProjectCard(item, itemId);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Material(
                        // Add Material widget here
                        child: AddProjectForm(),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Project'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRequestCard(Map<String, dynamic> request, String requestId) {
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
              request['description'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Level: ${request['level']}'),
                const SizedBox(height: 5),
                const Text('Members:'),
                for (var member in request['members'].values) Text('- $member'),
                const SizedBox(height: 5),
                Text('Skills: ${request['skills']}'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await accept(uid, request['studentUid'], requestId,
                        request['docid'], request);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Done!')));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    reject(uid, requestId);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProjectCard(Map<String, dynamic> project, String projectId) {
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
              project['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Description: ${project['description']}'),
                const SizedBox(height: 5),
                Text('Min Peoples: ${project['min peoples']}'),
                const SizedBox(height: 5),
                Text('Reserved: ${project['reserved'] ? "Yes" : "Not Yet"}'),
                if (project['reserved'])
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamDetails(
                              studentUid: project['studentUid'],
                              projectid: projectId),
                        ),
                      );
                    },
                    child: const Text('Team Details'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
