import 'package:cloud_firestore/cloud_firestore.dart';

// utils
import 'package:demo_project/models/user.dart';
class FirestoreService{
  FirebaseFirestore firestoreService = FirebaseFirestore.instance;

  Future<bool> addUser(UserModel user) async{
    try{
      // Create a CollectionReference called users that references the firestore collection
      final docUser = firestoreService.collection('users').doc(user.email.toLowerCase());

      // add data to docUser
      final jsonData = user.toJson();
      docUser.set(jsonData);
      return true;
    } catch (e){
      print("error firestore");
      print(e);
      return false;
    }
  }

  Future<UserModel?> getUser(String email) async {
    try{
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(email.toLowerCase());
      final documentSnapshot = await docUser.get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(documentSnapshot.data()!);
      } else {
        return null;
      }
    } catch(e){
      print("error get user");
      print(e); 
      return null;
    }

  }
}