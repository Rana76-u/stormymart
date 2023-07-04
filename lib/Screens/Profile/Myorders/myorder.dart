import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Profile/Myorders/pending_order.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              const Text(
                'My Orders',
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5,),

              const PendingOrders(),
            ],
          ),
        ),
      ),
    );
  }
}
