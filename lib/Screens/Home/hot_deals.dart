import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Components/custom_image.dart';
import '../../theme/color.dart';
import '../Product Screen/product_screen.dart';
class HotDeals extends StatefulWidget {
  const HotDeals({super.key});

  @override
  State<HotDeals> createState() => _HotDealsState();
}

class _HotDealsState extends State<HotDeals> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('/Products')
            .where('keywords', arrayContains: 'Hot Deals')
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            return SizedBox(
              width: double.infinity,
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if(snapshot.hasData) {
                    DocumentSnapshot product = snapshot.data!.docs[index];
                    double discountCal = (product.get('price') / 100) * (100 - product.get('discount'));
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProductScreen(productId: product.id))
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            //width: 200,
                            width: MediaQuery.of(context).size.width*0.48,
                            height: 300,
                            child: Stack(
                              children: [
                                //Pulls image from variation 1's 1st image
                                FutureBuilder(
                                  future: FirebaseFirestore
                                      .instance
                                      .collection('/Products/${product.id}/Variations').get(),
                                  builder: (context, snapshot) {
                                    if(snapshot.hasData){
                                      String docID = snapshot.data!.docs.first.id;
                                      return FutureBuilder(
                                        future: FirebaseFirestore
                                            .instance
                                            .collection('/Products/${product.id}/Variations').doc(docID).get(),
                                        builder: (context, imageSnapshot) {
                                          if(imageSnapshot.hasData){
                                            return CustomImage(
                                            imageSnapshot.data?['images'][0],
                                            radius: 10,
                                            width: 200,
                                            height: 210,//210
                                          );
                                          }else if(imageSnapshot.connectionState == ConnectionState.waiting){
                                            return const Center(
                                              child: LinearProgressIndicator(),
                                            );
                                          }
                                          else{
                                            return const Center(
                                              child: Text(
                                                "Nothings Found",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }
                                    else if(snapshot.connectionState == ConnectionState.waiting){
                                      return const Center(
                                        child: LinearProgressIndicator(),
                                      );
                                    }
                                    else{
                                      return const Center(
                                        child: Text(
                                          "Nothings Found",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),

                                //Discount %Off
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade800,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding:   const EdgeInsets.all(7),
                                      child: Text(
                                        'Discount: ${product.get('discount')}%',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //Title
                                Positioned(
                                  top: 220,
                                  left: 5,
                                  child: Text(
                                    product.get('title'),
                                    style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.black45//darker
                                    ),
                                  ),
                                ),

                                //price
                                Positioned(
                                    top: 240,
                                    left: 5,
                                    child: Row(
                                      children: [
                                        /*SvgPicture.asset(
                                          "assets/icons/taka.svg",
                                          width: 17,
                                          height: 17,
                                        ),*/
                                        Text(
                                          "Tk ${discountCal.toStringAsFixed(2)}/-",
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                              color: textColor),
                                        ),
                                      ],
                                    )
                                ),

                                //Row
                                Positioned(
                                  top: 260,
                                  left: 2,
                                  child:  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 3,),
                                      //Rating
                                      Text(
                                        product.get('rating').toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.grey.shade400//darker
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      //Sold
                                      Text(
                                        "${product.get('sold').toString()} Sold",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.grey.shade400//darker
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    );

                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: LinearProgressIndicator(),
                    );
                  }
                  else{
                    return const Center(
                      child: Text(
                        "Nothings Found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: LinearProgressIndicator(),
            );
          }
          else{
            return const Center(
              child: Text(
                "Nothings Found",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                ),
              ),
            );
          }
        },
      ),
    );
  }
}