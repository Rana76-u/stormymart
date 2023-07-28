import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Profile/login.dart';
import 'package:stormymart/Screens/Profile/Myorders/myorder.dart';
import 'package:stormymart/Screens/Profile/profile_top.dart';
import 'package:stormymart/utility/auth_service.dart';

import '../../utility/bottom_nav_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //Requests Permission to send notification
    requestPermission();
    getToken();
    _checkAndSaveUser();
    //initInfo();
    //_loadUserInfo();
    //_saveUserInfos();
  }

  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('Permission Granted');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Granted as Provisional');
    }else{
      print('Denied');
    }
  }

  String? phoneToken = '';
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
          setState(() {
            phoneToken = token;
            print("My token is $phoneToken");
          });
          saveTokenInFirebase(token!);
        }
    );
  }
  void saveTokenInFirebase(String token) async {
    await FirebaseFirestore.instance.collection('userTokens').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'token': token,
    });
  }

  _checkAndSaveUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;

    final userData = await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    if (!userData.exists) {
      // Save user data if the user is new
      FirebaseFirestore.instance.collection('userData').doc(uid).set({
        'name' : FirebaseAuth.instance.currentUser?.displayName,
        'imageURL' : FirebaseAuth.instance.currentUser?.photoURL,
        'Email': FirebaseAuth.instance.currentUser?.email,
        'Phone Number': '',
        'Gender': 'not selected',
        'Address1': ['Address1 Not Found','not selected'],
        'Address2': ['Address2 Not Found','not selected'],
        'coins': 1000,
        'coupons': 0,
        'wishlist': 0
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: FirebaseAuth.instance.currentUser == null ?
        const LoginPage() :
        SingleChildScrollView(
          child: Column(
            children: [
              const ProfileTop(),

              //Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    //Buttons
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //My Orders
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const MyOrders(),)
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20, top: 10),
                                child: Row(
                                  children: [
                                    //Bike Icon
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                        color: Colors.amber,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.delivery_dining_outlined, color: Colors.white, size: 22,),
                                      ),
                                    ),
                                    //Text
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        'My Orders',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.5,
                                            fontFamily: 'Urbanist'
                                        ),
                                      ),
                                    ),

                                    const Spacer(),
                                    //Forward button
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Track
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  //Bike Icon
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: Color(0xFFFB8500),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.track_changes_outlined, color: Colors.white, size: 22,),
                                    ),
                                  ),
                                  //Blood Donation Posts
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      'Track Order',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.5,
                                          fontFamily: 'Urbanist'
                                      ),
                                    ),
                                  ),

                                  const Spacer(),
                                  //Forward button
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            //Returns
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  //Bike Icon
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: Color(0xff023047),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.keyboard_return, color: Colors.white, size: 22,),
                                    ),
                                  ),
                                  //Blood Donation Posts
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      'Returns',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.5,
                                          fontFamily: 'Urbanist'
                                      ),
                                    ),
                                  ),

                                  const Spacer(),
                                  //Forward button
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            //About Us
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  //Bike Icon
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: Color(0xff219ebc),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.people, color: Colors.white, size: 22,),
                                    ),
                                  ),
                                  //Blood Donation Posts
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      'About Us',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.5,
                                          fontFamily: 'Urbanist'
                                      ),
                                    ),
                                  ),

                                  const Spacer(),
                                  //Forward button
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            //FeedBack
                            Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: Row(
                                children: [
                                  //Bike Icon
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: Colors.green,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.feedback_rounded, color: Colors.white, size: 22,),
                                    ),
                                  ),
                                  //Blood Donation Posts
                                  const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(
                                      'Feedback',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.5,
                                          fontFamily: 'Urbanist'
                                      ),
                                    ),
                                  ),

                                  const Spacer(),
                                  //Forward button
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          //Authservice().signOut();
                          try{
                            Authservice().signOut();
                            setState(() {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                              );
                            });
                          }catch(error){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error: $error')
                                )
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,//MaterialStateProperty.all(Colors.grey.shade200),
                          elevation: 0.0,
                        ),
                        child: const Text(
                          "Log out",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
