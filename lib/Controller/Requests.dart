import 'package:cloud_firestore/cloud_firestore.dart';

class Requests {
  final db = FirebaseFirestore.instance;


  Future<List<DocumentSnapshot<Map<String, dynamic>>>> emergencyRequests(String id) async {
    final doc = db.collection("emergencyAppointment");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await doc.where("userid", isEqualTo: id).get();
    List<DocumentSnapshot<Map<String, dynamic>>> documents ;

    if (querySnapshot.size == 0){
      return [];
    }
    else{
    documents = querySnapshot.docs;
    return documents;
    }

  }


  Future<List<DocumentSnapshot<Map<String, dynamic>>>> scheduleRequests(String id) async {
    final doc = db.collection("scheduleAppointment");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await doc.where("userid", isEqualTo: id).get();
    // List<DocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
    //
    // return documents;
    List<DocumentSnapshot<Map<String, dynamic>>> documents ;

    if (querySnapshot.size == 0){
      return [];
    }
    else{
      documents = querySnapshot.docs;
      return documents;
    }
  }


  Future<List<DocumentSnapshot<Map<String, dynamic>>>> winchRequests(String id) async {
    final doc = db.collection("winchAppointment");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await doc.where(
        "userid", isEqualTo: id).get();
    List<DocumentSnapshot<Map<String, dynamic>>> documents;

    if (querySnapshot.size == 0) {
      return [];
    }
    else {
      documents = querySnapshot.docs;
      return documents;
    }
  }

    Future<String> getName(String docId) {
      // Replace with your Firestore query to retrieve the string
      return FirebaseFirestore.instance
          .collection('BusinessOwners')
          .doc(docId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          return snapshot.get('name') as String;
        } else {
          return '';
        }
      });
  }


}

