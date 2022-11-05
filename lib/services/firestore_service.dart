import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project/models/user.dart';
class FirestoreService{
  FirebaseFirestore firestoreService = FirebaseFirestore.instance;

  Future<bool> addUser(User user) async{
    try{
      // Create a CollectionReference called users that references the firestore collection
      final docUser = firestoreService.collection('users').doc(user.email);

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

  Future<User?> getUser(String email) async {
    try{
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(email);
      final documentSnapshot = await docUser.get();
      if (documentSnapshot.exists) {
        return User.fromJson(documentSnapshot.data()!);
      } else {
        return null;
      }
    } catch(e){
      print(e); 
      return null;
    }

  }
}