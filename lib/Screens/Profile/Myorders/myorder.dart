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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                        Icons.arrow_back_rounded
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Text(
                    'My Orders',
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              const SizedBox(height: 5,),

              //Pending Order
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "• Pending Order",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist'
                  ),
                ),
              ),

              //PendingOrders,
              const PendingOrders(),

              const SizedBox(height: 200,),
            ],
          ),
        ),
      ),
    );
  }
}
