import 'package:demo_project/services/auth_services.dart';
import 'package:demo_project/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/models/user.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo_project/services/firestore_service.dart';
import 'package:demo_project/utils/locator.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthServices _authServices = locator<AuthServices>();
  bool isLoading = false;
  UserModel? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  Future<void> initData() async {
    setState(() {
      isLoading = true;
    });
    user = await _firestoreService.getUser(FirebaseAuth.instance.currentUser!.email!);
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        opacity: 0.5,
        color: Colors.deepPurple,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    user != null?
                    Text(
                      "Welcome " + user!.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800
                      ),
                    ): const Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      endIndent: size.width * 0.1,
                      indent: size.width * 0.1,
                    ),
                    user != null? Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                          ),
                          RichText(text: TextSpan(
                            text: "Email: " + user!.email + '\n \n',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,

                            ),
                            children: [
                              TextSpan(
                                text: "Name: " + user!.name + '\n \n',
                              ),
                              TextSpan(
                                text: "Gender: " + user!.gender + '\n \n',
                              ),
                              TextSpan(
                                text:"Year of birth: " + user!.yob + '\n \n',
                              ),
                            ]
                          )),

                        ],
                      ),
                    ): const SizedBox(height: 0,),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: RoundedButton(text: "Logout", press: () async{
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await _authServices.logout();
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e){
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





