import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WishListBody extends StatefulWidget {
  const WishListBody({super.key});

  @override
  State<WishListBody> createState() => _WishListBodyState();
}

class _WishListBodyState extends State<WishListBody> {

  bool isLoading = false;
  bool isDeleting = false;

  List<dynamic> productTitles = [];
  List<dynamic> productPrices = [];
  List<dynamic> productDiscounts = [];
  List<dynamic> productRatings = [];
  List<dynamic> productImages = [];

  List<dynamic> wishListItemIds = [];

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchWishListItems();
  }

  void fetchWishListItems() async {
    final wishlistSnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    wishListItemIds = wishlistSnapshot.get('wishlist');

    await fetchProductDetails();
    await fetchProductImages();
  }

  Future<void> fetchProductDetails() async {
    for (int i = 0; i < wishListItemIds.length; i++) {
      final productSnapshot = await FirebaseFirestore.instance
          .collection('/Products')
          .doc(wishListItemIds[i].trim())
          .get();

      productTitles.add(productSnapshot.get('title'));
      productPrices.add(productSnapshot.get('price'));
      productDiscounts.add(productSnapshot.get('discount'));
      productRatings.add(productSnapshot.get('rating'));

    }
  }

  Future<void> fetchProductImages() async {
    for (int i = 0; i < wishListItemIds.length; i++) {
      final productSnapshot = await FirebaseFirestore.instance
          .collection('/Products/${wishListItemIds[i]}/Variations')
          .get();

      //String docID = productSnapshot.data!.docs.first.id;
      String variationID = productSnapshot.docs.first.id;

      final variationSnapshot = await FirebaseFirestore.instance
          .collection('/Products/${wishListItemIds[i]}/Variations')
          .doc(variationID)
          .get();

      productImages.add(variationSnapshot.get('images')[0]);

    }

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: isLoading ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.35,),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: const LinearProgressIndicator(),
                ),
              ),
            ],
          )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${wishListItemIds.length.toString()} items',
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w400
            ),
          ),
          if(wishListItemIds.isNotEmpty)...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isDeleting ?
              const Center(
                child: LinearProgressIndicator(),
              ) :
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: wishListItemIds.length,
                itemBuilder: (context, index) {
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
                          onPressed: (context) async {

                            setState(() {
                              isLoading = true;
                            });

                            await FirebaseFirestore
                                .instance
                                .collection('/userData')
                                .doc(FirebaseAuth.instance.currentUser!.uid).update({
                              'wishlist': FieldValue.arrayRemove([wishListItemIds[index]])
                            });

                            setState(() {
                              wishListItemIds.removeAt(index);
                              isLoading = false;
                            });
                          },
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child:  Image.network(
                                    productImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            //Texts
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.48,//200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Title
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: Text(
                                      productTitles[index],
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
                                      'Price: ${productPrices[index]} BDT',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),

                                  //Discount
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      'Discount: ${productDiscounts[index]}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),

                                  //Rating
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      'Rating: ${productRatings[index]}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54
                                      ),
                                    ),
                                  ),
                                ],
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
          ],
        ],
      ),
    );
  }
}
