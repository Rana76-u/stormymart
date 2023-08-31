import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Cart/cart.dart';
import 'package:stormymart/Screens/Profile/profile_accountinfo.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';

class CheckOut extends StatefulWidget {

  double usedCoins = 0.0;
  double coinDiscount = 0.0;
  String usedPromoCode = '';
  double itemsTotal = 0.0;
  double promoDiscount = 0.0;

  CheckOut({
    super.key,
    required this.usedCoins,
    required this.usedPromoCode,
    required this.itemsTotal,
    required this.promoDiscount,
    required this.coinDiscount
  });

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  String randomID = "";
  String randomOrderListDocID = '';
  String? selectedAddress = '';
  bool isLoading = false;
  Random random = Random();
  int randomNumber = 0;

  @override
  void initState() {
    generateRandomID();
    super.initState();
  }

  void generateRandomID() {
    Random random = Random();
    const String chars = "0123456789abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 20; i++) {
      randomID += chars[random.nextInt(chars.length)];
    }
  }

  void generateRandomOrderListDocID() {
    Random random = Random();
    const String chars = "0123456789abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 20; i++) {
      randomOrderListDocID += chars[random.nextInt(chars.length)];
    }
  }

  void fetchCartItemsAndPlaceOrder() async {

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Cart')
        .get();

    //Enable Order Collection
    await FirebaseFirestore
        .instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid).set({
      'enable': true
    });

    //Order necessary details
    await FirebaseFirestore
        .instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Pending Orders').doc(randomID).set({
      'usedPromoCode': widget.usedPromoCode,
      'usedCoin': widget.usedCoins,
      'total' : widget.itemsTotal,
      'time' : DateFormat('EE, dd/MM/yyyy H:mm:s').format(DateTime.now()),
    });

    //Each Order Details
    for (var doc in cartSnapshot.docs) {
      //For every Cart item
      generateRandomOrderListDocID();
      // add them into Order list
      await FirebaseFirestore
          .instance
          .collection('Orders')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Pending Orders').doc(randomID).collection('orderLists').doc(randomOrderListDocID).set({
        'productId' : doc['id'],
        'quantity' : doc['quantity'],
        'selectedSize' : doc['selectedSize'],
        'variant' : doc['variant'],
      });

      //At shop location save the reference
      // Reference to the orderLists document
      DocumentReference orderListsReference = FirebaseFirestore.instance
          .collection('Orders')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Pending Orders')
          .doc(randomID)
          .collection('orderLists')
          .doc(randomOrderListDocID);

      // Update the '/Admin Panel' document with the reference value
      await FirebaseFirestore.instance
          .collection('/Admin Panel')
          .doc(doc['Shop ID'])
          .set({
        'Pending Orders': FieldValue.arrayUnion([orderListsReference])
      }, SetOptions(merge: true));

      //Then Delete added item from cart
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Cart')
          .doc(doc.id).delete();
    }

    //Decrease Coin Value
    double previousCoins = 0.0;
    double remainingCoins = 0.0;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    previousCoins = snapshot.get('coins').toDouble();

    remainingCoins = previousCoins - widget.usedCoins;

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'coins' : remainingCoins
    });
  }  ///////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Cart(),)
            );
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
                if(selectedAddress == ''){
                  selectedAddress = snapshot.data!.get('Address1')[0];
                }
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: DropdownButton<String>(
                                  value: selectedAddress ?? 'no address found',
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 25,
                                  elevation: 16,
                                  isExpanded: true,
                                  autofocus: true,
                                  style: TextStyle(
                                    color: selectedAddress == 'Address1 Not Found' || selectedAddress == 'Address2 Not Found'
                                        ? Colors.red
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  underline: const SizedBox(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedAddress = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    snapshot.data!.get('Address1')[0] ?? 'Address1 Not Found',
                                    snapshot.data!.get('Address2')[0] ?? 'Address2 Not Found',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const AccountInfo(),)
                                  );
                                },
                                child: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //order summary
                              const Text(
                                'Order Summary ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Urbanist'
                                ),
                              ),
                              const SizedBox(height: 10,),

                              //used coins
                              Text(
                                'Coin Discount (${widget.usedCoins}) : ${widget.coinDiscount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Urbanist',
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              const SizedBox(height: 5,),

                              //promo
                              Text(
                                'Promo Discount ( ${widget.usedPromoCode} ) : ${widget.promoDiscount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Urbanist',
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                              const SizedBox(height: 5,),

                              //total
                              Text(
                                'Total Payable Amount : ${widget.itemsTotal}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Urbanist',
                                    color: Colors.green,
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Place Order Button
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                      child: isLoading ?
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(13.5),
                                child: Text(
                                  'Placing Order',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Urbanist',
                                      fontSize: 17
                                  ),
                                ),
                              ),
                              LinearProgressIndicator()
                            ],
                          ),
                        ),
                      ) :
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: (){

                                    setState(() {
                                      isLoading = true;
                                    });

                                    if(selectedAddress == 'Address1 Not Found' || selectedAddress == 'Address2 Not Found'){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('Please add at least 1 address')
                                          )
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }else{
                                      fetchCartItemsAndPlaceOrder();

                                      setState(() {
                                        isLoading = false;

                                        if(isLoading == false){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text('Congratulations 🎉, Your Order has been Placed.')
                                              )
                                          );

                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 0),)
                                          );
                                        }
                                      });
                                    }
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.green)
                                  ),
                                  child: const Text(
                                    'Place Order',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
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
