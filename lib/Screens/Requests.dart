import 'package:cloud_firestore/cloud_firestore.dart';

class Requests {
  final db = FirebaseFirestore.instance;

  // Future<QuerySnapshot<Map<String, dynamic>>> emergencyRequests(String id){
  //   final doc = db.collection("emergencyAppointment");
  //   return doc.where("userid",isEqualTo: id).get();
  // }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> emergencyRequests(String id) async {
    final doc = db.collection("emergencyAppointment");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await doc.where("userid", isEqualTo: id).get();
    List<DocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;

    return documents;
  }


  // Future<QuerySnapshot<Map<String, dynamic>>> scheduleRequests(String id){
  //   final doc = db.collection("scheduleAppointment");
  //   return doc.where("userid",isEqualTo: id).get();
  // }
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> scheduleRequests(String id) async {
    final doc = db.collection("scheduleAppointment");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await doc.where("userid", isEqualTo: id).get();
    List<DocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;

    return documents;
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> winchRequests(String id){
  //   final doc = db.collection("scheduleAppointment");
  //   return doc.where("userid",isEqualTo: id).get();
  // }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> winchRequests(String id) async {
    final doc = db.collection("winchAppointment");
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await doc.where("userid", isEqualTo: id).get();
    List<DocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;

    return documents;
  }
}