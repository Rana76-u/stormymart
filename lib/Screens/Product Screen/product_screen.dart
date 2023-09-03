import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:stormymart/Screens/Chat%20Screen/chat_screen.dart';
import 'package:stormymart/theme/color.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';

import '../../Components/image_viewer.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String variationDocID = '';
  String imageSliderDocID = '';
  int quantity = 1;
  int variationCount = 0;
  int clickedIndex = 0;
  List<dynamic> sizes = [];

  bool variationWarning = false;
  bool sizeWarning = false;

  void checkLength() async {
    String id = widget.productId.toString().trim();
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('/Products/$id/Variations')
        .get();

    variationCount = snapshot.docs.length;
    imageSliderDocID = snapshot.docs.first.id;
  }

  @override
  void initState() {
    super.initState();
    checkLength();
  }

  int sizeSelected = -1;
  Color _cardColor(int i) {
    if (sizeSelected == i) {
      return Colors.green;
    }
    else {
      return Colors.white;
    }
  }

  int variationSelected = -1;
  Color _variationCardColor(int i) {
    if (variationSelected == i) {
      return Colors.green;
    }
    else {
      return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    String id = widget.productId.toString().trim();
    var shopID = '';

    return Scaffold(
      backgroundColor: appBgColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(productId: widget.productId),
              )
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: const Icon(
              Icons.messenger
          ),
        ),
      ),
      body: Column(
        children: [
          //Space
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),

          //Screen
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.928,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Products')
                      .doc(id)
                      .get()
                      .then((value) => value),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      var price = snapshot.data!.get('price');
                      var discount = snapshot.data!.get('discount');
                      double discountCal = (price / 100) * (100 - discount);
                      var rating = snapshot.data!.get('rating');
                      var sold = snapshot.data!.get('sold');
                      var quantityAvailable = snapshot.data!.get('quantityAvailable');
                      shopID = snapshot.data!.get('Shop ID');

                      //SIZE LIST
                      sizes = snapshot.data!.get('size');

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Space From TOP
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),

                          //Arrow Button
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, top: 7, bottom: 6),
                              child: Icon(
                                Icons.arrow_back,
                              ),
                            ),
                          ),

                          //ImageSlider
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Products/$id/Variations')
                                .doc(imageSliderDocID)
                                .get()
                                .then((value) => value),
                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                List<dynamic> images =
                                snapshot.data!.get('images');
                                return images.isNotEmpty ?
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: ImageSlideshow(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height * 0.42,//0.45
                                        initialPage: 0,
                                        indicatorColor: Colors.amber,
                                        indicatorBackgroundColor: Colors.grey,
                                        onPageChanged: (value) {},
                                        autoPlayInterval: 7000,
                                        isLoop: true,
                                        children:
                                        List.generate(images.length, (index) {
                                          return GestureDetector(
                                            onTap: (){
                                              /*showImageViewer(
                                                  context,
                                                  NetworkImage(images[index]),
                                                  swipeDismissible: true,
                                                  doubleTapZoomable: true
                                              );*/
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) => ImageViewerScreen(imageUrl: images[index],),)
                                              );
                                            },
                                            child: Image.network(
                                              images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        })),
                                  ),
                                ) :  Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.45,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        'https://cdn.dribbble.com/users/256646/screenshots/17751098/media/768417cc4f382d6171053ad620bc3c3b.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),

                          //Space
                          const SizedBox(height: 5,),

                          //Variation Name & Images
                          Container(
                            height: variationWarning ? 140 : 114,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: variationWarning ? Colors.red.withOpacity(0.25) : appBgColor,
                            ),
                            child: ListView.builder(
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: variationCount,
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                  future: FirebaseFirestore
                                      .instance
                                      .collection('/Products/$id/Variations')
                                      .get()
                                      .then((value) => value),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      variationDocID = snapshot.data!.docs[index].id;
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //Name
                                          Container(
                                            margin: const EdgeInsets.only(top: 5, left: 11),
                                            width: 70,
                                            child: Text(
                                              //snapshot.data!.docs[index].id,
                                              variationDocID,
                                              style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                          //image
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                variationSelected = index;
                                                imageSliderDocID = snapshot.data!.docs[index].id;
                                                variationWarning = false;
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(top: 5,left: 10, right: 15, bottom: 15),
                                              width: 70,//200
                                              height: 70,//136.5

                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: variationWarning == false ?
                                                    _variationCardColor(index) : Colors.red,
                                                    width: 2,//5
                                                  ),
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: FutureBuilder(
                                                future: FirebaseFirestore.instance
                                                    .collection('/Products/$id/Variations')
                                                    .doc(variationDocID) //place String value of selected variation
                                                    .get()
                                                    .then((value) => value),
                                                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                  if (snapshot.hasData) {
                                                    List<dynamic> images =
                                                    snapshot.data!.get('images');
                                                    return ImageSlideshow(
                                                        initialPage: 0,
                                                        indicatorColor: Colors.amber,
                                                        indicatorBackgroundColor: Colors.grey,
                                                        onPageChanged: (value) {},
                                                        autoPlayInterval: 3500,
                                                        isLoop: true,
                                                        children: List.generate(images.length, (index) {
                                                          return ClipRRect(
                                                            borderRadius: BorderRadius.circular(8),
                                                            child: Image.network(
                                                              images[index],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          );
                                                        }));
                                                  } else {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          if (variationWarning == true)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15),
                                              child: Container(
                                                color: Colors.red,
                                                alignment: Alignment.center,
                                                child: const Padding(
                                                  padding: EdgeInsets.only(left: 4, right: 4),
                                                  child: Text(
                                                    'Please select a variation',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'Urbanist',
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    } else {
                                      return const Text(
                                        'No Variations',
                                        style: TextStyle(color: Colors.grey),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),

                          if (variationWarning == true)
                            const SizedBox(height: 7,),

                          //Product Info Card
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  //Discount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Discount
                                      if(discount == 0.0)...[
                                        const SizedBox(),
                                      ]
                                      else...[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade800,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding:   const EdgeInsets.all(10),
                                            child: Text(
                                              'Discount: $discount%',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],

                                      //wishlist
                                      GestureDetector(
                                        onTap: () async {
                                          final messenger = ScaffoldMessenger.of(context);
                                          await FirebaseFirestore
                                              .instance
                                              .collection('/userData')
                                              .doc(FirebaseAuth.instance.currentUser!.uid).update({
                                            'wishlist': FieldValue.arrayUnion([id])
                                          });

                                          messenger.showSnackBar(
                                              const SnackBar(
                                                  content: Text('Item added to Wishlist')
                                              )
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: const Padding(
                                            padding:   EdgeInsets.all(7),
                                            child: Text(
                                              '+ wishlist',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Title
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 5, left: 0, right: 5),
                                    child: Text(
                                      snapshot.data!.get('title'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.grey.shade700
                                      ),
                                    ),
                                  ),

                                  //Price
                                  Row(
                                    children: [
                                      Text(
                                        "BDT ${discountCal.toStringAsFixed(0)}/-",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21.5,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      if(discount == 0.0)...[
                                        const SizedBox(),
                                      ]
                                      else...[
                                        Text(
                                          "of ${price.toString()}/-",
                                          style: const TextStyle(
                                            //fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.lineThrough
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),

                                  //Rating & Sold
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 3,),
                                        //Rating
                                        Text(
                                          rating.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.grey.shade600//darker
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        //Sold
                                        Text(
                                          "${sold.toString()} Sold",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.grey.shade600//darker
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Description
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      snapshot.data!.get('description'),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),

                                  //Show Sizes
                                  if(sizes.isEmpty)...[const SizedBox()]
                                  else...[
                                    SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        itemCount: sizes.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                sizeSelected = index;
                                                sizeWarning = false;
                                              });
                                            },
                                            child: Card(
                                              color: sizeWarning == false ? _cardColor(index) : Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100)
                                              ),//CircleBorder()
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
                                                  child: Text(
                                                    sizes[index],
                                                    style: TextStyle(
                                                      color: sizeSelected == index || sizeWarning
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],

                                  // Quantity
                                  if(quantityAvailable == 0)...[
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '*Sold Out',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber
                                        ),
                                      ),
                                    ),
                                  ]
                                  else...[
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10, bottom: 5),
                                      child: Text(
                                        'Select Quantity',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 39,//42
                                      width: MediaQuery.of(context).size.width * 0.41,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                // Decrement quantity
                                                setState(() {
                                                  if (quantity != 1) {
                                                    quantity--;
                                                  }
                                                });
                                              },
                                            ),
                                            Text(quantity.toString()),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                // Increment quantity
                                                setState(() {
                                                  quantity++;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          //Store info Card
                          FutureBuilder(
                            future: FirebaseFirestore
                                .instance
                                .collection('/Admin Panel')
                                .doc(shopID)
                                .get(),
                            builder: (context, shopSnapshot) {
                              if(shopSnapshot.hasData){
                                String shopName = shopSnapshot.data!.get('Shop Name');
                                int followerNumber = shopSnapshot.data!.get('Follower Number');
                                String shopLogo = shopSnapshot.data!.get('Shop Logo');
                                String email = shopSnapshot.data!.get('Email');
                                String phoneNumber = shopSnapshot.data!.get('Phone Number');
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            //Logo
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: SizedBox(
                                                height: 60,
                                                width: 60,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: Image.network(
                                                          shopLogo == '' ? 'https://www.senbagcollege.gov.bd/midea/featuredimage/featuredimage2017-06-09-18-13-52_593ac940872ee.jpg' : shopLogo
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //Shop Info
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 150,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      //Shop Name
                                                      Text(
                                                        shopName == '' ? 'Not Yet Set' : shopName,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Urbanist',
                                                        ),
                                                      ),

                                                      //Followers
                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 20),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Colors.grey.shade50
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 3, bottom: 3, left: 5, right: 5),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                    Icons.person_outlined,
                                                                  size: 12.5,
                                                                  color: Colors.grey.shade600,
                                                                ),
                                                                Text(
                                                                  ' $followerNumber',
                                                                  style: const TextStyle(
                                                                    fontFamily: 'Urbanist',
                                                                    fontSize: 9,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //Email
                                                  SelectableText(
                                                    email,
                                                    style: const TextStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 11
                                                    ),
                                                  ),
                                                  //Phone Number
                                                  SelectableText(
                                                    phoneNumber == '' ? 'Phone Number Not Yet Set' : phoneNumber,
                                                    style: const TextStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 11
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        //Space
                                        const SizedBox(height: 10,),

                                        //Follow Button
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            //Visit Shop Button
                                            SizedBox(
                                              height: 31,
                                              width: MediaQuery.of(context).size.width*0.5,
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  //foregroundColor: Colors.white,
                                                  //backgroundColor: Colors.teal,
                                                    side: const BorderSide(
                                                        width: 1,
                                                        color: Colors.amber
                                                    ),
                                                ), onPressed: () {  },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.store_mall_directory_rounded,
                                                      size: 17,
                                                      color: Colors.amber,
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text(
                                                      'Visit Shop',
                                                      style: TextStyle(
                                                        color: Colors.amber,
                                                        fontFamily: 'Urbanist',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 8,),
                                            //Follow Button
                                            SizedBox(
                                              height: 31,
                                              child: ElevatedButton(
                                                  onPressed: () {

                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(Colors.orange)
                                                  ),
                                                  child: const Text(
                                                    '+ Follow',
                                                    style: TextStyle(
                                                      fontFamily: 'Urbanist',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  )
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              else if(shopSnapshot.connectionState == ConnectionState.waiting){
                                return const Center(
                                  child: LinearProgressIndicator(),
                                );
                              }
                              else{
                                return const Center(
                                  child: Text('Error While Loading'),
                                );
                              }
                            },
                          ),

                          //Space At the BOTTOM
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      );
                    }
                    else {
                      return Center(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*0.45,),
                          const CircularProgressIndicator(),
                        ],
                      ),
                    );
                    }
                  },
                ),
              ),
            ),
          ),

          // Add to Cart Button
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Products')
                .doc(id)
                .get()
                .then((value) => value),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if(snapshot.hasData){
                var price = snapshot.data!.get('price');
                var discount = snapshot.data!.get('discount');
                double discountCal = (price / 100) * (100 - discount);
                var quantityAvailable = snapshot.data!.get('quantityAvailable');
                var shopID = snapshot.data!.get('Shop ID');

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.070,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, right: 30, left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade600,
                                  fontSize: 14
                              ),
                            ),
                            Text(
                              'BDT ${discountCal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.32,
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            onPressed: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              final mediaQuery = MediaQuery.of(context);

                              if(FirebaseAuth.instance.currentUser != null){
                                setState(() {
                                  sizeWarning = false;
                                  variationWarning = false;
                                });
                                if(quantityAvailable == 0){
                                  messenger.showSnackBar(
                                    const SnackBar(content: Text('Product Got Sold Out'))
                                  );
                                }
                                else{
                                  if(sizeSelected == -1 && sizes.isNotEmpty){
                                    setState(() {
                                      sizeWarning = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Select Size')));
                                  }
                                  else if(variationSelected == -1){
                                    setState(() {
                                      variationWarning = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Select Variant')));
                                  }
                                  else{
                                    String uid = FirebaseAuth.instance.currentUser!.uid;

                                    await FirebaseFirestore.instance.collection('userData/$uid/Cart/')
                                        .doc()
                                        .set({
                                      //'1': FieldValue.arrayUnion(valuesToAdd)
                                      'Shop ID': shopID,
                                      'id': id,
                                      'selectedSize': sizeSelected == -1 ? 'not applicable' : sizes[sizeSelected].toString(),
                                      'variant': imageSliderDocID,
                                      'quantity': quantity
                                    });

                                    messenger.showSnackBar(
                                        SnackBar(
                                          content: GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 2),));
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: mediaQuery.size.width*0.4,
                                                  child: const Text(
                                                    'Congratulations 🎉, Your Product added to the cart.',
                                                    style: TextStyle(
                                                        overflow: TextOverflow.clip
                                                    ),
                                                  ),
                                                ),
                                                if(mounted)...[
                                                  SizedBox(
                                                    width: mediaQuery.size.width*0.4,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                      ),
                                                      onPressed: (){
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 2),));
                                                      },
                                                      child: const Text(
                                                        'Open Cart',
                                                        style: TextStyle(
                                                            fontFamily: 'Urbanist',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14.5
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              ],
                                            ),
                                          ),
                                          duration: const Duration(seconds: 3),
                                        )
                                    );
                                  }
                                }
                              }else{
                                messenger.showSnackBar(
                                    SnackBar(
                                      content: GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 2),));
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: mediaQuery.size.width*0.4,
                                              child: const Text(
                                                'You\'re not logged in',
                                                style: TextStyle(
                                                    overflow: TextOverflow.clip
                                                ),
                                              ),
                                            ),
                                            if(mounted)...[
                                              SizedBox(
                                                width: mediaQuery.size.width*0.4,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                  ),
                                                  onPressed: (){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),));
                                                  },
                                                  child: const Text(
                                                    'Log In',
                                                    style: TextStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14.5
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                          ],
                                        ),
                                      ),
                                      duration: const Duration(seconds: 3),
                                    )
                                );
                              }
                            },
                            child: const Text(
                                'Add to Cart',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              else if(snapshot.connectionState == ConnectionState.waiting){
                return SizedBox(
                  width: MediaQuery.of(context).size.width*0.4,
                  child: const LinearProgressIndicator(),
                );
             }
              else{
                return const Text('Error Loading');
              }
            },
          ),
        ],
      ),
    );
  }
}
