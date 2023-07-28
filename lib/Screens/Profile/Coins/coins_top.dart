import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoinsTop extends StatelessWidget {
  const CoinsTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.055,), //0.05, 0.075
          //Top BAR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Arrow back
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: const Icon(
                    Icons.arrow_back_ios
                ),
              ),

              const Text(
                'Coins',
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold
                ),
              ),

              //Profile Photo
              GestureDetector(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2.5, color: Colors.grey.shade400),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
