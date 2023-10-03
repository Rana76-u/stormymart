import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Profile/profile.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BottomBar(bottomIndex: 3),
                )
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: const Icon(
              Icons.arrow_back_rounded
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),

              const Text(
                'Contacts',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                    fontSize: 25
                ),
              ),

              const SizedBox(height: 20,),

              const SelectableText(
                'Phone: 016 2724 0496, 01606-557967\n'
                'Email: stormymartofficial@gmail.com\n'
                    'https://www.facebook.com/stormymart\n'
                'Address: Banasree, Dhaka, Bangladesh',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  height: 1.5
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
