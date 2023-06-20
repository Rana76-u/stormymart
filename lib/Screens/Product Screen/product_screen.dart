import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:stormymart/theme/color.dart';

import '../../Components/image_viewer.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String variationDocID = '';
  String imageSliderDocID = '';
  int quantity = 1;
  int variationCount = 0;
  int clickedIndex = 0;
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
    } else {
      return Colors.white;
    }
  }

  int variationSelected = -1;
  Color _variationCardColor(int i) {
    if (variationSelected == i) {
      return Colors.green;
    } else {
      return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    String id = widget.productId.toString().trim();
    return Scaffold(
      backgroundColor: appBgColor,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
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

                      //SIZE LIST
                      List<dynamic> sizes = snapshot.data!.get('size');
                      List<SizedBox> sizeWidget = [];
                      for (int i = 0; i < sizes.length; i++) {
                        sizeWidget.add(
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  sizeSelected = i;
                                });
                              },
                              child: Card(
                                color: _cardColor(i),
                                shape: const CircleBorder(),
                                child: Center(
                                  child: Text(
                                    sizes[i],
                                    style: TextStyle(
                                      color: sizeSelected == i
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

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

                          //Variation Name & Images
                          SizedBox(
                            height: 112,
                            width: double.infinity,
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
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          //image
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                variationSelected = index;
                                                imageSliderDocID = snapshot.data!.docs[index].id;
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(top: 5,left: 10, right: 15, bottom: 15),
                                              width: 70,//200
                                              height: 70,//136.5

                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: _variationCardColor(index),
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
                                                        width: 200, //double.infinity,
                                                        height: 300, //MediaQuery.of(context).size.height * 0.45,
                                                        initialPage: 0,
                                                        indicatorColor: Colors.amber,
                                                        indicatorBackgroundColor: Colors.grey,
                                                        onPageChanged: (value) {},
                                                        autoPlayInterval: 3500,
                                                        isLoop: true,
                                                        children: List.generate(images.length, (index) {
                                                          return Image.network(
                                                            images[index],
                                                          );
                                                        }));
                                                  } else {
                                                    return const Center(
                                                      child:
                                                      CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          )
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

                          //Discount
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

                          //SIZES
                          if(sizeWidget.isNotEmpty)...[
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                children: sizeWidget,
                              ),
                            ),
                          ],

                          // Quantity
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

                          //Space At the BOTTOM
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                            onPressed: () {
                              if(sizeSelected == -1){
                                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Select Size')));
                              }else if(variationSelected == -1){
                                ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Select Variant')));
                              }else{
                                /*Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => OrderScreen(
                          id: id,
                          size: sizeSelected,
                          variant: imageSliderDocID,
                          quantity: quantity,
                        ),
                        ),
                      );*/
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
                return const LinearProgressIndicator();
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
