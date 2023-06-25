import 'package:cloud_firestore/cloud_firestore.dart';


class CurrentRequests {
  final db = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> pendingRequests(String id) async {
    final doc1 = db.collection("emergencyAppointment");
    final doc2 = db.collection("scheduleAppointment");
    final doc3 = db.collection("winchAppointment");

    QuerySnapshot<Map<String, dynamic>> querySnapshot1 = await doc1
        .where("mechanicid", isEqualTo: id)
        .where("state", isEqualTo: "pending")
        .where("done", isEqualTo: false)
        .get();
    QuerySnapshot<Map<String, dynamic>> querySnapshot2 = await doc2
        .where("mechanicid", isEqualTo: id)
        .where("state", isEqualTo: "pending")
        .where("done", isEqualTo: false)
        .get();
    QuerySnapshot<Map<String, dynamic>> querySnapshot3 = await doc3
        .where("mechanicid", isEqualTo: id)
        .where("state", isEqualTo: "pending")
        .where("done", isEqualTo: false)
        .get();

    List<DocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot1.docs +
            querySnapshot2.docs +
            querySnapshot3.docs;

    return documents;
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> acceptedRequests(String id) async {
    final doc1 = db.collection("emergencyAppointment");
    final doc2 = db.collection("scheduleAppointment");
    final doc3 = db.collection("winchAppointment");

    QuerySnapshot<Map<String, dynamic>> querySnapshot1 = await doc1
        .where("mechanicid", isEqualTo: id)
        .where("state", isEqualTo: "accepted")
        .where("done", isEqualTo: false)
        .get();
    QuerySnapshot<Map<String, dynamic>> querySnapshot2 = await doc2
        .where("mechanicid", isEqualTo: id)
        .where("state", isEqualTo: "accepted")
        .where("done", isEqualTo: false)
        .get();
    QuerySnapshot<Map<String, dynamic>> querySnapshot3 = await doc3
        .where("mechanicid", isEqualTo: id)
        .where("state", isEqualTo: "accepted")
        .where("done", isEqualTo: false)
        .get();

    List<DocumentSnapshot<Map<String, dynamic>>> documents =
        querySnapshot1.docs +
            querySnapshot2.docs +
            querySnapshot3.docs;

    return documents;
  }

  Future<String> getName(String docId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        return snapshot.get('fullName') as String;
      } else {
        return '';
      }
    });
  }
  Future<String> getNumber(String docId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        return snapshot.get('phoneNumber') as String;
      } else {
        return '';
      }
    });
  }
}