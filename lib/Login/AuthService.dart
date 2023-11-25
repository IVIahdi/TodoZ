import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String documentId, String email, String username) async {
    await todosCollection.doc(documentId).set({
      'email': email,
      'username': username,
    });
  }
}

class FirestoreService {
  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>?> getUserData(String documentId) async {
    var userDoc = await todosCollection.doc(documentId).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
