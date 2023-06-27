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

  Future<String> getRate(String id) async {
    // Specify the collection names to search in
    List<String> collectionNames = ['emergencyAppointment', 'scheduleAppointment', 'winchAppointment'];

    dynamic rate = '';
    // Perform queries on each collection
    for (String collectionName in collectionNames) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .get();

      if (snapshot.exists) {
        rate = snapshot.get('rate');
        break; // Exit the loop if the rate is found
      }
    }

    if (rate == 0){
      rate = 'No rating yet';
    }

    return rate.toString();


  }
}

