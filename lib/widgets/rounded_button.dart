import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: const Color(0xff682bd7),
          ),
          onPressed: (){
            press();
          },
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white,
              fontWeight: FontWeight.w700
            ),
          ),
        ),
      ),
    );
  }
}