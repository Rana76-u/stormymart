import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PendingOrders extends StatefulWidget {
  const PendingOrders({super.key});

  @override
  State<PendingOrders> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore
          .instance
          .collection('/Orders/${FirebaseAuth.instance.currentUser!.uid}/Pending Orders')
          .get(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Pending Order (${snapshot.data!.docs.length})",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist'
                  ),
                ),
              ),
              if(snapshot.data!.docs.isNotEmpty)...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.redAccent.withAlpha(60),
                            icon: Icons.cancel_rounded,
                            label: 'Cancel Order',
                            autoClose: true,
                            borderRadius: BorderRadius.circular(15),
                            spacing: 5,
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.all(10),
                            onPressed: (context) async {
                              /*deleteDocument(index);
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 2),)
                              );*/
                            },
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: Row(
                          children: [
                            //Image
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('/Products/${snapshot.data!.docs[index].get('productId')}/Variations')
                                  .doc(snapshot.data!.docs[index].get('variant'))
                                  .get(),
                              builder: (context, imageSnapshot) {
                                if(imageSnapshot.hasData){
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12, left: 12),
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child:  Image.network(
                                          imageSnapshot.data!.get('images')[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }else if(imageSnapshot.connectionState == ConnectionState.waiting){
                                  return Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.4,
                                      child: const LinearProgressIndicator(),
                                    ),
                                  );
                                }else {
                                  return const Center(
                                    child: Text(
                                      'Error Loading Image',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),

                            //Texts
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('/Products')
                                  .doc(snapshot.data!.docs[index].get('productId'))
                                  .get(),
                              builder: (context, titleSnapshot) {
                                if(titleSnapshot.hasData){
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width*0.48,//200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //Title
                                        Padding(
                                      padding: const EdgeInsets.only(top: 25),
                                      child: Text(
                                        titleSnapshot.data!.get('title'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                        //Price
                                        Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        'Price: ${titleSnapshot.data!.get('price')} BDT',
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
                                            'Size: ${snapshot.data!.docs[index].get('selectedSize')}',
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
                                            'Variant: ${snapshot.data!.docs[index].get('variant')}',
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
                                            'Quantity: ${snapshot.data!.docs[index].get('quantity')}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }else if(snapshot.connectionState == ConnectionState.waiting){
                                  return Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.4,
                                      child: const LinearProgressIndicator(),
                                    ),
                                  );
                                }else {
                                  return const Center(
                                    child: Text(
                                      'Error Loading Data',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ]else...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Nothing to Show',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontFamily: 'Urbanist'
                      ),
                    ),
                  ),
                )
              ]
            ],
          );
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: const LinearProgressIndicator(),
            ),
          );
        }else {
          return const Center(
            child: Text(
              'Error Loading Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }
}
