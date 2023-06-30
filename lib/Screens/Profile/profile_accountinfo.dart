import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utility/bottom_nav_bar.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {

  bool _isDataLoaded = false;
  bool _updateLoading = false;

  String name = '';
  String image = '';
  String gender = '';
  String email = '';
  String phone = '';
  String address1 = '';
  String address2 = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();

  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('userData');

  @override
  void initState() {
    super.initState();
    _checkAndSaveUser();
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
        'Address1': '',
        'Address2': '',
        'coins': 0,
        'coupons': 0,
        'wishlist': 0
      });
    }
    else{
      _readData();
    }
  }

  _readData() async{
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    final DocumentReference documentReference =
    FirebaseFirestore.instance.collection('userData').doc(uid);

    await documentReference.get().then( (DocumentSnapshot snapshot) {
      if(snapshot.exists){
        name = snapshot['name'];
        image = snapshot['imageURL'];
        gender = snapshot['Gender'];
        email = snapshot['Email'];
        phone = snapshot['Phone Number'];

        address1 = snapshot['Address1'];
        address2 = snapshot['Address2'];

        nameController.text = name;
        imageController.text = image;
        genderController.text = gender;
        emailController.text = email;
        phoneNumberController.text = phone;
        address1Controller.text = address1;
        address2Controller.text = address2;

        setState(() {
          _isDataLoaded = true;
        });
      }
    });
  }

  Future<void> _updatePersonalDetails() async{
    setState(() {
      _updateLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    await _collectionReference.doc(uid).update({
      'name' : nameController.text,
      'Email' : emailController.text,
      'Gender' : gender,
      'Phone Number': phoneNumberController.text,
      'Address1': address1Controller.text,
      'Address2': address2Controller.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isDataLoaded){
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.030),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Blank Space
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              //"Account Details" Text
              Padding(
                padding: const EdgeInsets.only(bottom: 4,left: 7),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    const Text(
                      "Account Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              //Details
              SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Name"),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: nameController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "name . . . ",
                              hintStyle: const TextStyle(
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.abc),
                              //labelText: "Semester",
                            ),
                          ),
                        ),

                        const Text("E-Mail"),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "example@mail.com",
                              hintStyle: const TextStyle(
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.abc),
                              //labelText: "Semester",
                            ),
                          ),
                        ),

                        const Text("Select Gender"),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<String>(
                            value: gender,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 25,
                            elevation: 16,
                            isExpanded: true,
                            autofocus: true,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                gender = newValue!;
                              });
                            },
                            items: <String>[
                              'Male',
                              'Female',
                              'others',
                              'not selected'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),

                        const Text("Phone Number"),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: phoneNumberController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "ex: +880... ",
                              hintStyle: const TextStyle(
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.onetwothree),
                              //labelText: "Semester",
                            ),
                          ),
                        ),

                        const Text("Delivery Location 1"),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: address1Controller,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "address1",
                              hintStyle: const TextStyle(
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.abc),
                              //labelText: "Semester",
                            ),
                          ),
                        ),

                        const Text("Delivery Location 2"),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: address2Controller,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "address2",
                              hintStyle: const TextStyle(
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.abc),
                              //labelText: "Semester",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 33,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    if(
                        nameController.text == '' ||
                        phoneNumberController.text == '' ||
                        address1Controller.text == ''
                    ){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Name & Phone Number can not be empty"),
                            duration: Duration(milliseconds: 1500),
                          ));
                    }else{
                      _updatePersonalDetails();
                      setState(() {
                        _updateLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Information Update Successful"),
                            duration: Duration(milliseconds: 1500),
                          ));
                    }
                  },
                  child: const Text("Update"),
                ),
              ),
              _updateLoading == true ? const LinearProgressIndicator() : const SizedBox(),
            ],
          ),
        ),
      );
    }else{
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
