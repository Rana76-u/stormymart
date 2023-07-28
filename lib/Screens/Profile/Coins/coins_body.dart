import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoinsBody extends StatefulWidget {
  const CoinsBody({super.key});

  @override
  State<CoinsBody> createState() => _CoinsBodyState();
}

class _CoinsBodyState extends State<CoinsBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text
            const Text(
              'Remaining Coins: ',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.bold
              ),
            ),

            //Coin Number
            FutureBuilder(
              future:  FirebaseFirestore
                  .instance
                  .collection('userData')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Text(
                        snapshot.data!.get('coins').toString(),
                        style: const TextStyle(
                            fontSize: 50,
                            color: Colors.amber,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  );
                }else if(snapshot.connectionState == ConnectionState.waiting){
                  return const LinearProgressIndicator();
                }else{
                  return const Center(child: Text('Error Loading Data'),);
                }
              },
            ),

            const Divider(),

            //conversion rate txt
            const Text(
              'Conversion Rates of Coins: \n1 Tk for 25 coins',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.clip,

              ),
            ),

            const SizedBox(height: 50,),

            //instruction txt
            const Text(
              'Instructions on how to earn more & more coins by simple tasks and buying',
              style: TextStyle(
                fontSize: 15,
                overflow: TextOverflow.clip,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
