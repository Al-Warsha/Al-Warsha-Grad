import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Models/businessOwner_model.dart';
import '../../../Models/emegencyAppointment.dart';
import '../../../Models/scheduleAppointment.dart';
import '../../../Models/winchAppointment.dart';



CollectionReference getScheduleCollection()
{
  return FirebaseFirestore.instance.collection('scheduleAppointment').withConverter<scheduleAppointment>
    (fromFirestore: (snapshot, options)
  => scheduleAppointment.fromJson(snapshot.data()!),
    toFirestore: (value, options) => value.toJson(),
  );
}

Future<void> addScheduleToFireStore(scheduleAppointment appointment){
  var collection=getScheduleCollection();
  var docRef= collection.doc();
  appointment.id=docRef.id;
  return docRef.set(appointment);

}

CollectionReference getWinchCollection()
{
  return FirebaseFirestore.instance.collection('winchAppointment').withConverter<winchAppointment>
    (fromFirestore: (snapshot, options)
  => winchAppointment.fromJson(snapshot.data()!),
    toFirestore: (value, options) => value.toJson(),
  );
}

Future<void> addWinchToFireStore(winchAppointment appointment){
  var collection=getWinchCollection();
  var docRef= collection.doc();
  appointment.id=docRef.id;
  return docRef.set(appointment);

}

CollectionReference getemergencyCollection()
{
  return FirebaseFirestore.instance.collection('emergencyAppointment').withConverter<emergencyAppointment>
    (fromFirestore: (snapshot, options)
  => emergencyAppointment.fromJson(snapshot.data()!),
    toFirestore: (value, options) => value.toJson(),
  );
}

Future<void> addemergencyToFireStore(emergencyAppointment appointment){
  var collection=getemergencyCollection();
  var docRef= collection.doc();
  appointment.id=docRef.id;
  return docRef.set(appointment);

}


Future<List<BusinessOwnerModel>> getAllBusinessOwners() async {
  final snapshot = await FirebaseFirestore.instance
      .collection("BusinessOwners")
      .where("verified", isEqualTo: true)
      .where("rejected", isEqualTo: false)
      .get();
  final businessOwnerData = snapshot.docs
      .map((e) => BusinessOwnerModel.fromSnapshot(
    e,

  )).toList();
  return businessOwnerData.cast<BusinessOwnerModel>();
}

Future<BusinessOwnerModel?> getBusinessOwnerDetails(String? id) async {
  final snapshot = await FirebaseFirestore.instance.collection("BusinessOwners").doc(id).get();
  final businessOwnerData = BusinessOwnerModel.fromSnapshot(
    snapshot,


  );
  return businessOwnerData;
}

Future<String?> getBusinessOwnerId(String? id) async {
  final snapshot = await FirebaseFirestore.instance.collection("BusinessOwners").doc(id).get();
  final businessOwnerData = BusinessOwnerModel.fromSnapshot(
    snapshot,


  );
  return businessOwnerData.id;
}



Future<Map<String, dynamic>> getUserData(String userId) async {
  try {
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.data() as Map<String, dynamic>;
  } catch (e) {
    print('Error fetching user data: $e');
    return {};
  }
}
Future<List<DocumentSnapshot<Map<String, dynamic>>>> getReviews(String mechanicid) async {
  // Specify the collection names to search in
  List<String> collectionNames = ['emergencyAppointment', 'scheduleAppointment', 'winchAppointment'];

  List<DocumentSnapshot<Map<String, dynamic>>> dataList = [];

  // Perform queries on each collection
  for (String collectionName in collectionNames) {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('mechanicid', isEqualTo: mechanicid)
        .get();


    for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot in snapshot.docs) {
      if (docSnapshot.data()['rate'] != 0) {
        dataList.add(docSnapshot);
      }
    }
  }
  return dataList;
}

Future<num> avgRate(String mechanicId) async {
  final db = FirebaseFirestore.instance;

  List<DocumentSnapshot<Map<String, dynamic>>> reviews = await getReviews(mechanicId);
  DocumentReference documentRef =  db.collection('BusinessOwners').doc(mechanicId);

  if (reviews.isEmpty) {
    // No reviews found
    await documentRef.update({'rate': 0});
    return 0;
  }

  num totalRate = 0;
  for(int i = 0; i< reviews.length; i++){
    totalRate += reviews[i].data()?['rate'];
  }

  num avg = totalRate/reviews.length;


  await documentRef.update({'rate': avg});

  return avg;

}




