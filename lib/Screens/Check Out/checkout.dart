import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  String selectedAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            'Chekcout',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: const Icon(
              Icons.arrow_back_ios_new_rounded
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: FirebaseFirestore
                .instance
                .collection('userData')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Column(
                  children: [
                    //Card 1
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Deliver to
                              const Text(
                                'Deliver to: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Urbanist'
                                ),
                              ),
                              const SizedBox(height: 10,),
                              
                              //name
                              Text(
                                'Name : ${snapshot.data!.get('name')}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Urbanist',
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              const SizedBox(height: 5,),
                              //phone
                              Text(
                                'Phone Number : ${snapshot.data!.get('Phone Number')}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Urbanist',
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              const SizedBox(height: 5,),
                              //email
                              Text(
                                'E-mail : ${snapshot.data!.get('Email')}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Urbanist',
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              const SizedBox(height: 5,),
                              //address
                              const Text(
                                'Select Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Urbanist',
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              DropdownButton<String>(
                                value: selectedAddress,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 25,
                                elevation: 16,
                                isExpanded: true,
                                autofocus: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                hint: const Text('Select Location'),
                                underline: const SizedBox(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedAddress = newValue!;
                                  });
                                },
                                items: <String>[
                                   snapshot.data!.get('Address1').toString(),
                                   snapshot.data!.get('Address2').toString(),
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10,),
                              
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.greenAccent.withOpacity(0.15)
                                ),
                                width: double.infinity,
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Click Here To Edit Details',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Urbanist',
                                        overflow: TextOverflow.ellipsis,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //Card 2
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [

                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: LinearProgressIndicator(),);
              }else {
                return const Center(child: Text(
                  'Error Loading Data: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist'
                  ),
                ),);
              }
            },
          ),
        ),
      ),
    );
  }
}
