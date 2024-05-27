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
        .update({'reserved': true});
    await firestore
        .collection('teachers')
        .doc(uid)
        .collection('projects')
        .doc(pid)
        .collection('teams')
        .add(teamData);
    await firestore
        .collection('students')
        .doc(stuid)
        .update({'reserved': true});
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
