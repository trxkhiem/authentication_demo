import 'package:flutter/material.dart';
import 'package:demo_project/widgets/text_field_container.dart';
import 'package:email_validator/email_validator.dart';
import 'package:demo_project/widgets/rounded_button.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();

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
                          "Log in",
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
                            "Forgot your password",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.2,
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
                            "Don't have an account? Register now!",
                            style: TextStyle(
                                color: Color(0xff682bd7),
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        RoundedButton(
                          text: "Register",
                          press: (){
                            //_login(context);
                          },
                        ),
                      ],
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
