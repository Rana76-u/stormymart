import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stormymart/Screens/Cart/delivery_container.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {

    String uid = FirebaseAuth.instance.currentUser!.uid;
    String variant = '';
    int size = 0;
    int quantity = 0;
    String title = '';
    var price = 0;
    var discount = 0;
    double discountMoney = ( (price * quantity) /100 ) * discount;
    double deliveryCharge = 50.0;
    double subTotal = (price * quantity) - discountMoney + deliveryCharge;
    double discountCal = 0.0;

    return Scaffold(
      body: FirebaseAuth.instance.currentUser == null ?
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: SizedBox()),
                const Text(
                  'StormyMart',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Login to access the cart',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    fontFamily: 'Urbanist'
                  ),
                ),
                const SizedBox(height: 10,),

                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),));
                    },
                    child: const Text(
                      'Go to Login Page',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ) :
      SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('/userData/$uid/Cart').get(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              int itemLength = snapshot.data!.docs.length;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                    const Text(
                      'My Cart',
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DeliveryContainer(),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${itemLength.toString()} items',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      String id = snapshot.data!.docs[index].get('id');
                                      variant = snapshot.data!.docs[index].get('variant');
                                      size = snapshot.data!.docs[index].get('selectedSize');
                                      quantity = snapshot.data!.docs[index].get('quantity');

                                      return Slidable(
                                        endActionPane: ActionPane(
                                          motion: const BehindMotion(),
                                          children: [
                                            SlidableAction(
                                              backgroundColor: Colors.redAccent.withAlpha(60),
                                              icon: Icons.delete,
                                              label: 'Delete',
                                              autoClose: true,
                                              borderRadius: BorderRadius.circular(15),
                                              spacing: 5,
                                              foregroundColor: Colors.redAccent,
                                              padding: const EdgeInsets.all(10),
                                              onPressed: (context) {},
                                              ),
                                          ],
                                        ),
                                        child: SizedBox(
                                          height: 170,
                                          width: double.infinity,
                                          child: Card(
                                            elevation: 0,
                                            child: Row(
                                              children: [
                                                //Image
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 12),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width*0.40 - 25,//150,
                                                    height: 137,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 4,
                                                            color: Colors.transparent
                                                        ),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: FutureBuilder(
                                                      future: FirebaseFirestore.instance
                                                          .collection('/Products/$id/Variations') //Product ID from Previous Page
                                                          .doc(variant) //Product Variant ID from Previous Page
                                                          .get()
                                                          .then((value) => value),
                                                      builder: (context, AsyncSnapshot<DocumentSnapshot> variationSnapshot) {
                                                        if (variationSnapshot.hasData) {
                                                          String image = variationSnapshot.data?.get('images')[0];
                                                          //List<dynamic> images = snapshot.data?.get('images');
                                                          return ClipRRect(
                                                            borderRadius: BorderRadius.circular(15),
                                                            child:  Image.network( image,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          );
                                                        } else {
                                                          return const Center(
                                                            child:
                                                            CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                //Texts
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.48,//200,
                                                  child: FutureBuilder(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('/Products')
                                                        .doc(id) //Product ID Here
                                                        .get(),
                                                    builder: (context, AsyncSnapshot<DocumentSnapshot> infoSnapshot) {
                                                      if(infoSnapshot.hasData){
                                                        title = infoSnapshot.data!.get('title');
                                                        price = infoSnapshot.data!.get('price');
                                                        discount = infoSnapshot.data!.get('discount');
                                                        discountCal = (price / 100) * (100 - discount);

                                                        discountMoney = ( (price * quantity) /100 ) * discount;
                                                        subTotal = (price * quantity) - discountMoney + deliveryCharge;

                                                        return Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            //Title
                                                            Expanded(
                                                              flex: -1,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 25),
                                                                child: Text(
                                                                  title,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    fontSize: 17,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            //Price
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 5),
                                                              child: Text(
                                                                'Price: $discountCal BDT',
                                                                style: const TextStyle(
                                                                    fontSize: 15,
                                                                    color: Colors.black54,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            ),

                                                            //Size
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 5),
                                                              child: Text(
                                                                'Size: $size',
                                                                style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black54
                                                                ),
                                                              ),
                                                            ),

                                                            //Variant
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 2),
                                                              child: Text(
                                                                'Variant: $variant',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black54
                                                                ),
                                                              ),
                                                            ),

                                                            //Quantity
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 2),
                                                              child: Text(
                                                                'Quantity: $quantity',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                    fontSize: 14,
                                                                    color: Colors.black54
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }else{
                                                        return const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Calculation
                    //First Line
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Title * Quantity
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.45 - 20,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('$price × $quantity'),
                          // = Price
                          Text('${price * quantity}')
                          //Discount
                        ],
                      ),
                    ),

                    //Discount Line
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount $discount%'),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              '- ${discountMoney.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  color: Colors.red
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Delivery Charge Line
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Charge'),
                          Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                '50',
                              )
                          ),
                        ],
                      ),
                    ),

                    //Dotted Divider Line
                    const DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Colors.black54,
                      //dashGradient: [Colors.red, Colors.blue],
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: Colors.transparent,
                      //dashGapGradient: [Colors.red, Colors.blue],
                      dashGapRadius: 0.0,
                    ),

                    //Subtotal Line
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              'Subtotal'
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              subTotal.toStringAsFixed(1),
                            ),
                          )
                        ],
                      ),
                    ),

                  ]
                )
              );
            }
            else if(snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
            }
            else{
              return const Center(
                child: Text(
                  'Data not found',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }
}
