import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:demo_project/widgets/text_field_container.dart';
import 'package:email_validator/email_validator.dart';
import 'package:demo_project/widgets/rounded_button.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  String gender = "Gender";
  String dob = "Date of birth";
  bool isChecked = false;
  final TextEditingController _passwordField = TextEditingController();




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
                        TextFieldContainer(
                          child: TextFormField(
                            controller: _emailField,
                            keyboardType: TextInputType.text,
                            cursorColor: const Color(0xff682bd7),
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontFamily: "Montserrat"
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
                      //_login(context);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: (){
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return ResetPasswordScreen();
                      //     },
                      //   ),
                      // );
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
          )
      ),
    );
  }
}
