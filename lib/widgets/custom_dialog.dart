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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Column(
                  children: [
                    Text(
                      title == null? 'ERROR': title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,

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
                    const SizedBox(height: 15,),
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
                        padding: EdgeInsets.all(5.0),
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
            ),
            const Positioned(
                top: -50,
                child: CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 35,
                  child: Icon(Icons.error,
                    color: Colors.white,
                    size: 60,
                  ),
                )
            ),
          ],
        )
    );
  }
}