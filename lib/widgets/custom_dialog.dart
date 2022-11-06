import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String? title;
  final String? alertMessage;

  const CustomAlert({Key? key, this.title, this.alertMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
        ),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          height: 250,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      title == null? 'ERROR': title!,
                      style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          color: title != null && title == "Email sent"?Colors.green : Colors.red,

                          fontSize: 20),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: Text(
                        alertMessage == null? 'There is something wrong.\n Please check again!!': alertMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    backgroundColor: Colors.deepPurpleAccent
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                    child: Text('OK',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}