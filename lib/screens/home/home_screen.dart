import 'package:flutter/material.dart';

// services
import 'package:demo_project/services/auth_services.dart';
import 'package:demo_project/services/firestore_service.dart';

// widgets
import 'package:demo_project/widgets/custom_dialog.dart';
import 'package:demo_project/widgets/rounded_button.dart';

// utils
import 'package:demo_project/models/user.dart';
import 'package:demo_project/utils/locator.dart';

// packages
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isVerified = false;

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
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }


  void refreshVerify() async{
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isLoading = false;
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("user");
    print(user);
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
                           Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Profile",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                isVerified? Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal:5.0),
                                      child: Text(
                                        "Verified",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.deepPurpleAccent
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Colors.deepPurple,
                                    ),
                                  ],
                                ): Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        bool result = await _authServices.verifyUser();
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (result){
                                          showDialog(context: context,
                                              builder: (BuildContext context) {
                                                return const CustomAlert(
                                                  title: "Email sent",
                                                  alertMessage: "Please follow the sent email for verification.",
                                                );
                                              });
                                        } else {
                                          showDialog(context: context,
                                              builder: (BuildContext context) {
                                                return const CustomAlert();
                                              });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          backgroundColor: Colors.deepPurpleAccent
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text('Verify Email',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    GestureDetector(
                                      onTap: (){
                                        refreshVerify();
                                      },
                                      child: const Icon(
                                        Icons.refresh,
                                        size: 28,
                                      ),
                                    )
                                  ],
                                )
                              ],
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





