import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  Future<String> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password).timeout(const Duration(seconds: 20));
      return "success";
    } on FirebaseAuthException catch (e) {
      if(e.code.replaceAll("-", " ") == "wrong password"){
        return "Your email/password is incorrect. Please try again";
      } else {
        return e.code.replaceAll("-", " ");
      }
    } catch (e) {
      return "Network issues! Please try again later";
    }
  }


  Future<void> verifyUser() async{
    User user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification();
  }

  Future<String?> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.code.replaceAll("-", " ");
    }
  }

  Future <bool> resetPassword(String email) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> logout() async {
    try{
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e){
      return false;
    }
  }
}