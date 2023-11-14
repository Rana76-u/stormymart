import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Profile/Myorders/canceled_orders.dart';
import 'package:stormymart/Screens/Profile/Myorders/completed_order.dart';
import 'package:stormymart/Screens/Profile/Myorders/pending_order.dart';
import 'package:stormymart/Screens/Profile/Myorders/processing_orders.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(
                fontSize: 22,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Processing'),
              Tab(text: 'Completed'),
              Tab(text: 'Canceled'),
            ],
          ),
          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey),
        ),
        body: TabBarView(
          children: [
            // First Tab - Pending Orders
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    /*Row(
                      children: [
                        //Arrow
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                            );
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
                    ),*/

                    //PendingOrders,
                    const PendingOrders(),

                    const SizedBox(height: 200,),
                  ],
                ),
              ),
            ),

            // Second Tab - Processing Orders
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    /*Row(
                      children: [
                        //Arrow
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                            );
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
                    ),*/

                    //PendingOrders,
                    const ProcessingOrders(),

                    const SizedBox(height: 200,),
                  ],
                ),
              ),
            ),

            // Third Tab - Completed Orders
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    /*Row(
                      children: [
                        //Arrow
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                            );
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
                    ),*/

                    //PendingOrders,
                    const CompletedOrders(),

                    const SizedBox(height: 200,),
                  ],
                ),
              ),
            ),

            // Forth Tab - Canceled Orders
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),

                    //PendingOrders,
                    const CanceledOrders(),

                    const SizedBox(height: 200,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
