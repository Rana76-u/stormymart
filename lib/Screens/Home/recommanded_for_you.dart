import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';
import 'package:stormymart/utility/globalvariable.dart';

import '../../Components/custom_image.dart';
import '../../theme/color.dart';
import '../Product Screen/product_screen.dart';

class RecommendedForYou extends StatefulWidget {
  const RecommendedForYou({super.key});

  @override
  State<RecommendedForYou> createState() => _RecommendedForYouState();
}

class _RecommendedForYouState extends State<RecommendedForYou> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('/Products')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          return Expanded(
            flex: 0,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.59,
                crossAxisSpacing: 2,//10
                mainAxisSpacing: 5,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if(snapshot.hasData){
                  DocumentSnapshot product = snapshot.data!.docs[index];
                  double discountCal = (product.get('price') / 100) * (100 - product.get('discount'));
                  return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProductScreen(productId: product.id))
                          );
                        },
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
                        ),
                      )
                  );
                }else{
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        }else{
          return const Center(
            child: Text(
                'NOTHING TO SHOW'
            ),
          );
        }
      },
    );
  }
}

class RecommendedForYouTitle extends StatelessWidget {
  const RecommendedForYouTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recommanded For You',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Urbanist'
            ),
          ),

          GestureDetector(
            onTap: () {
              keyword = null;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 1),)
              );
            },
            child: const Text(
              'See All',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: 'Urbanist'
              ),
            ),
          ),
        ],
      );
  }
}
