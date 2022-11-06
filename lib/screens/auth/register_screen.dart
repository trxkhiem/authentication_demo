import 'package:demo_project/models/user.dart';
import 'package:demo_project/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

// external packages
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// widgets
import 'package:demo_project/widgets/text_field_container.dart';
import 'package:demo_project/widgets/rounded_button.dart';

// services
import 'package:demo_project/services/auth_services.dart';
import 'package:demo_project/services/firestore_service.dart';

// utils
import 'package:demo_project/utils/locator.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameField = TextEditingController();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  // default values for gender and dob

  // String type to display date
  String yob = "Year of birth";
  List<String> yearList = <String>['Year of birth','before 1965', 'From 1965 to 2000', 'After 2000'];

  List<String> genderList = <String>['Gender','Male', 'Female', 'Other'];
  String gender = "Gender";



  // default value for privacy checkbox
  bool isChecked = false;
  final TextEditingController _passwordField = TextEditingController();

  final AuthServices _authService = locator<AuthServices>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  bool isLoading = false;


  Future<void> _signup(BuildContext context) async {

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final response = await _authService.register(_emailField.text.trim(), _passwordField.text.trim());
        if (response == "success"){
          // success then do add details to firestore
          UserModel user = UserModel(
              name: _nameField.text,
              yob: yob == "Year of birth"?"": yob, // if user didn't choose any value, then send empty string
              email: _emailField.text.trim(),
              gender: gender == "Gender"? "": gender // if user didn't choose any value, then send empty string
          );
          final addDetailsResponse = await _firestoreService.addUser(user);
          setState(() {
            isLoading = false;
          });
          if (addDetailsResponse){
            Navigator.pop(context);
          } else {
            setState(() {
              isLoading = false;
            });
            // pop up dialog here
            showDialog(context: context,
                builder: (BuildContext context) {
                  return const CustomAlert();
                });
          }
        } else {
          setState(() {
            isLoading = false;
          });
          // pop up dialog here
          showDialog(context: context,
              builder: (BuildContext context) {
                return CustomAlert(title: "WARNING", alertMessage: response,);
              });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("debug error");
        print(e);
        showDialog(context: context,
            builder: (BuildContext context) {
              return const CustomAlert(title: "WARNING");
            });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: LoadingOverlay(
            isLoading: isLoading,
            opacity: 0.5,
            color: Colors.deepPurple,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.07),
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Let's begin",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Color(0xff682bd7)
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              controller: _nameField,
                              keyboardType: TextInputType.text,
                              cursorColor: const Color(0xff682bd7),
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                ),
                                hintText: "Name*",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SizedBox(
                              width:size.width * 0.8,
                              child: DropdownButtonFormField<String>(
                                hint: const Text(
                                  "Year of Birth",
                                  style: TextStyle(
                                      color: Colors.black87
                                  ),
                                ),
                                value: yob,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xff682bd7),
                                ),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: const BorderSide(width: 0.5, color:  Color(0xff682bd7),)
                                    )
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    yob = value!;
                                  });
                                },
                                onSaved: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    yob = value!;
                                  });
                                },
                                items: yearList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                          width:size.width * 0.8,
                          child: DropdownButtonFormField<String>(
                            hint: const Text(
                              "Gender",
                              style: TextStyle(
                                color: Colors.black87
                              ),
                            ),
                            value: gender,
                            icon: const Icon(
                                Icons.keyboard_arrow_down,
                              color: Color(0xff682bd7),
                            ),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(29),
                                borderSide: const BorderSide(width: 0.5, color:  Color(0xff682bd7),)
                              )
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                gender = value!;
                              });
                            },
                            onSaved: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                gender = value!;
                              });
                            },
                            items: genderList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                          TextFieldContainer(
                            child: TextFormField(
                              controller: _emailField,
                              keyboardType: TextInputType.text,
                              cursorColor: const Color(0xff682bd7),
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                ),
                                hintText: "Email*",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                } else {
                                  bool isValid = EmailValidator.validate(value);
                                  print("------");
                                  print(isValid);
                                  if (!isValid){
                                    return 'Please enter correct email';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              controller: _passwordField,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              cursorColor: const Color(0xff682bd7),
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                hintText: "Password*",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                } else {
                                  if (value.length < 8){
                                    return 'Password needs to be at least 8 characters long.';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                          ),
                          TextFieldContainer(
                            child: TextFormField(
                              controller: _confirmPassword,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              cursorColor: const Color(0xff682bd7),
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                hintText: "Confirm password*",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password is required';
                                } else {
                                  if (value.length < 8){
                                    return 'Password needs to be at least 8 characters long.';
                                  }  else if(value != _passwordField.text){
                                    return 'Password does not match';
                                  }
                                  else {
                                    return null;
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isChecked,
                            activeColor: Colors.deepPurple,

                            shape: const CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          const Flexible(
                            child: Text(
                                "I have read the Term of Use and Privacy Policy and I want to proceed."
                            ),
                          )
                        ],
                      ),
                    ),
                    RoundedButton(
                      text: "Let's go",
                      press: (){
                        if (!isChecked){
                          showDialog(context: context,
                              builder: (BuildContext context) {
                                return const CustomAlert(title: "Privacy Agreement", alertMessage: "There is no agreed-upon privacy policy or terms of use.",);
                              });
                        } else {
                          _signup(context);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Already have a profile? Login",
                        style: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
