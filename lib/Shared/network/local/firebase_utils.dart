import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Models/businessOwner_model.dart';
import '../../../Models/emegencyAppointment.dart';
import '../../../Models/scheduleAppointment.dart';


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
      .where("verified", isEqualTo: false)
      .where("rejected", isEqualTo: false)
      .get();
  final businessOwnerData = snapshot.docs
      .map((e) => BusinessOwnerModel.fromSnapshot(e))
      .toList();
  return businessOwnerData.cast<BusinessOwnerModel>();
}

Future<BusinessOwnerModel?> getBusinessOwnerDetails(String? id) async {
  final snapshot = await FirebaseFirestore.instance.collection("BusinessOwners").doc(id).get();
  final businessOwnerData = BusinessOwnerModel.fromSnapshot(snapshot);
  return businessOwnerData;
}




