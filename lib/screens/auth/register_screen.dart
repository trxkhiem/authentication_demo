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
  String gender = "Gender";
  String dob = "Date of birth";

  // check if there is either gender or dob is missing
  bool isMissed = false;



  // default value for privacy checkbox
  bool isChecked = false;
  final TextEditingController _passwordField = TextEditingController();

  final AuthServices _authService = locator<AuthServices>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  bool isLoading = false;


  Future<void> _signup(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.register(_emailField.text.trim(), _passwordField.text.trim());
        if (response == "success"){
          // success then do add details to firestore
          User user = User(name: _nameField.text, dob: DateTime.parse(dob), email: _emailField.text.trim(), gender: gender);
          final addDetailsResponse = await _firestoreService.addUser(user);
          setState(() {
            isLoading = false;
          });
          if (addDetailsResponse){
            Navigator.pop(context);
          } else {
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
          isLoading = true;
        });
        showDialog(context: context,
            builder: (BuildContext context) {
              return const CustomAlert(title: "WARNING");
            });
      }
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text("Male"),
              trailing: const Icon(
                Icons.male_rounded
              ),
              onTap: () {
                setState(() {
                  gender = "Male";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Female"),
              trailing: const Icon(
                Icons.female_rounded
              ),
              onTap: () {
                setState(() {
                  gender = "Female";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Other"),
              trailing: const Icon(
                  Icons.transgender_rounded
              ),
              onTap: () {
                setState(() {
                  gender = "Other";
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
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
                                  bool isValid = EmailValidator.validate(value);
                                  if (isValid){
                                    return 'Please enter correct email';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1920, 1, 1),
                                    maxTime: DateTime.now(),
                                    onChanged: (date) {
                                      setState(() {
                                        dob = DateFormat('dd/MM/yyyy').format(date);
                                      });
                                    }, onConfirm: (date) {
                                      setState(() {
                                        dob = DateFormat('dd/MM/yyyy').format(date);
                                      });
                                    },
                                    currentTime: DateTime.now(), locale: LocaleType.en);
                              },
                            child: TextFieldContainer(
                              child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                         Text(
                                           dob,
                                           style: TextStyle(
                                             fontSize: 16,
                                             color:  dob == "Date of birth"?const Color(0xFF566071): Colors.black
                                           ),
                                         ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_outlined
                                        )
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                          isMissed && dob == "Date of birth"?
                          const Text(
                              "This field is required",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12
                            ),
                          ):const SizedBox(height: 0,),
                          GestureDetector(
                            onTap: (){
                                  _showPickOptionsDialog(context);
                                },
                            child: TextFieldContainer(
                              child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          gender,
                                          style:  TextStyle(
                                              fontSize: 16,
                                            color:  gender == "Gender"?const Color(0xFF566071): Colors.black,
                                          ),
                                        ),
                                        const Icon(
                                            Icons.keyboard_arrow_down_outlined
                                        )
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                          isMissed && dob == "Gender"?
                          const Text(
                            "This field is required",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12
                            ),
                          ):const SizedBox(height: 0,),
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
                                  if (isValid){
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
                        setState(() {
                          isMissed = false;
                        });
                        if (gender == "Gender" || dob == "Date of birth"){
                          setState(() {
                            isMissed = true;
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
