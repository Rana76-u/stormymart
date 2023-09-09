import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {

  bool isPosting = false;
  TextEditingController feedbackController = TextEditingController();

  String randomID = "";
  void generateRandomID() {
    Random random = Random();
    const String chars = "0123456789abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 20; i++) {
      randomID += chars[random.nextInt(chars.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),

              //Back Button
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Icon(Icons.arrow_back)
                ),
              ),

              //FeedBack
              const Text(
                'FeedBack',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              ),

              //Space
              const SizedBox(height: 10),

              //TextField
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 165,
                  maxHeight: 300,
                ),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: feedbackController,
                      style: const TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 14,
                          overflow: TextOverflow.clip
                      ),
                      decoration: const InputDecoration(
                          hintText: 'Write Suggestions / Complains about the functionalities of this app or StormyMart.',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none
                          )
                      ),
                      cursorColor: Colors.green,
                    ),
                  ),
                ),
              ),

              //Space
              const SizedBox(height: 15),

              //Send Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.green
                  ),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    if(feedbackController.text == ''){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('write something'))
                      );
                    }
                    else{
                      setState(() {
                        isPosting = true;
                      });

                      generateRandomID();

                      //Set of values to be uploaded
                      final postValues = <String, String>{
                        "feedback": feedbackController.text,
                        "posterUID": FirebaseAuth.instance.currentUser!.uid,
                        "postTime": DateFormat('EE, dd/MM/yyyy H:mm:s').format(DateTime.now()),
                      };

                      await FirebaseFirestore.instance
                          .collection("Feedbacks")
                          .doc(randomID)
                          .set({
                        ...postValues,  // using spread syntax to merge postValues into the same object
                      });

                      setState(() {
                        isPosting = false;
                      });

                      messenger.showSnackBar(
                          const SnackBar(
                              content: Text('Feedback posted Successfully.\nThanks for your valuable feedback.')
                          )
                      );
                      if(mounted) {
                        Navigator.of(context).pop();
                      }else{
                        return;
                      }
                    }
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              //Linear Loading
              SizedBox(
                  width: double.infinity,
                  child: isPosting
                      ? LinearProgressIndicator(
                    color: Colors.green.shade400,
                    backgroundColor: Colors.green.shade100,
                  )
                      : const SizedBox()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
