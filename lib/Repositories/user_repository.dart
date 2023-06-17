import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot snapshot =
      await usersCollection.doc(userId).get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> newData) async {
    try {
      await usersCollection.doc(userId).update(newData);
      print('User data updated successfully');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
