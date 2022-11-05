import 'package:flutter/material.dart';

// widgets
import 'package:demo_project/widgets/text_field_container.dart';
import 'package:demo_project/widgets/rounded_button.dart';
import 'package:demo_project/widgets/custom_dialog.dart';

// external packages
import 'package:email_validator/email_validator.dart';

// services
import 'package:demo_project/services/auth_services.dart';

// utils
import 'package:demo_project/utils/locator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailField = TextEditingController();
  final AuthServices _authService = locator<AuthServices>();
  bool isLoading = false;

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
                          "Forgot password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Color(0xff682bd7)
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: size.width * 0.8,
                          child: const Text(
                              "Enter the email address associated with your account and we'll email you a link to reset the password."
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
                                if (!isValid){
                                  return 'Please enter correct email';
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RoundedButton(
                          text: "Continue",
                          press: () async{
                            print("hello");
                            try{
                              bool result = await _authService.resetPassword(_emailField.text.trim());
                              print ("result here");
                              print (result);
                              if(result){

                              } else {
                                showDialog(context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlert();
                                    });
                              }
                            } catch (e) {
                              showDialog(context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlert();
                                  });
                            }

                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: RoundedButton(
                            text: "Cancel",
                            press: (){
                              Navigator.pop(context);
                            },
                          ),
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