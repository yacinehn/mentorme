import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorme/widgets.dart';

Future<void> accept(uid, stuid, rid, pid, teamData) async {
  try {
    print('we entered');
    await firestore
        .collection('teachers')
        .doc(uid)
        .collection('requests')
        .doc(rid)
        .delete();
    await firestore
        .collection('teachers')
        .doc(uid)
        .collection('projects')
        .doc(pid)
        .update({'reserved': true, 'studentUid': stuid});

    await firestore
        .collection('students')
        .doc(stuid)
        .update({'reserved': true});
    await firestore.collection('teachers').doc(uid).set({
      'studentUid': stuid,
    }, SetOptions(merge: true));
    await firestore.collection('students').doc(stuid).set({
      'teacherUid': uid,
    }, SetOptions(merge: true));
  } catch (e) {
    print(e);
  }
  // sent notification
}

Future<void> reject(uid, rid) async {
  await firestore
      .collection('teachers')
      .doc(uid)
      .collection('requests')
      .doc(rid)
      .delete();
  // send notification
}

Future<void> cancel(uid, pid, suid) async {
  await firestore
      .collection('teachers')
      .doc(uid)
      .collection('projects')
      .doc(pid)
      .set({
    'reserved': false,
    'studentUid': null,
  }, SetOptions(merge: true));

  await firestore
      .collection('students')
      .doc(suid)
      .set({'reserved': false, 'teacherUid': null}, SetOptions(merge: true));
}

Future<void> addProject(uid, Map<String, dynamic> projectData) async {
  await firestore
      .collection('teachers')
      .doc(uid)
      .collection('projects')
      .add(projectData);
}
