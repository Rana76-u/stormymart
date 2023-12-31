import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Cart/delivery_container.dart';
import 'package:stormymart/Screens/Product%20Screen/product_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../utility/bottom_nav_bar.dart';
import '../CheckOut/checkout.dart';
import 'package:get/get.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  double subTotal = 0.0;
  double total = 0.0;

  double promoDiscount = 0.0;
  double promoDiscountMoney = 0.0;

  bool isLoggedIn = false;
  bool isPromoCodeFound = false;
  String promoCode = '';
  double availableCoins = 0.0;
  double inputCoinAmount = 0.0;
  double coinDiscount = 0.0;

  List<dynamic> productTitles = [];
  List<dynamic> productPrices = [];
  List<int> productQuantityAvailable = [];

  List<String> cartItemIds = [];
  List<String> cartDocumentIds = [];
  List<String> cartItemSizes = [];
  List<String> cartItemVariants = [];
  List<int> cartItemQuantities = [];
  List<dynamic> productDiscounts = []; //was Int
  List<String> productImages = [];
  List<double> priceAfterDiscount = [];

  bool isLoading = false;
  bool isDeleting = false;

  List<String> allProductDocIds = [];
  List<bool?> selectedItems = [];
  bool isAllSelected = true;

  @override
  void initState() {
    super.initState();
    if(FirebaseAuth.instance.currentUser != null){
      isLoading = true;
      fetchAllProductDocIds();
    }
  }

  Future<void> fetchAllProductDocIds() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('/Products').get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      allProductDocIds.add(documentSnapshot.id);
    }
    fetchCartItems();
    fetchCoinData();
  }

  void fetchCartItems() async {
    final cartSnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('Cart')
        .get();

    for (var doc in cartSnapshot.docs) {
      cartDocumentIds.add(doc.id);
      cartItemIds.add(doc['id']);
      cartItemSizes.add(doc['selectedSize']);
      cartItemVariants.add(doc['variant']);
      cartItemQuantities.add(doc['quantity']);
    }

    await fetchProductDetails();
    await fetchProductImages();
    calculateSubtotal();
  }

  Future<void> fetchProductDetails() async {
    final navigator = Navigator.of(context);
    for (int i = 0; i < cartItemIds.length; i++) {

      if(allProductDocIds.contains(cartItemIds[i].trim())){
        final productSnapshot = await FirebaseFirestore.instance
            .collection('/Products')
            .doc(cartItemIds[i].trim())
            .get();

        productTitles.add(productSnapshot.get('title')); //productSnapshot.get('title')
        productPrices.add(productSnapshot.get('price')); //productSnapshot.get('price')
        productQuantityAvailable.add(productSnapshot.get('quantityAvailable')); //productSnapshot.get('price')
        productDiscounts.add(productSnapshot.get('discount')); //double.parse(productSnapshot.get('discount'))
        priceAfterDiscount.add((productSnapshot.get('price') / 100) * (100 - productSnapshot.get('discount')));

        if(productQuantityAvailable[i] == 0){
          await deleteDocument(i);
          navigator.push(
              MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 2),)
          );
        }
      }
      else{
        setState(() {

          FirebaseFirestore.instance
              .collection('userData')
              .doc(uid)
              .collection('Cart').doc(cartDocumentIds[i].trim()).delete();

          cartItemIds.removeAt(i);
          cartDocumentIds.removeAt(i);
        });
      }
    }
  }

  Future<void> fetchProductImages() async {
    for (int i = 0; i < cartItemIds.length; i++) {
      final productSnapshot = await FirebaseFirestore.instance
          .collection('/Products/${cartItemIds[i]}/Variations')
          .doc(cartItemVariants[i])
          .get();

      productImages.add(productSnapshot.get('images')[0]);

    }
    for (int i = 0; i < cartItemIds.length; i++) {
      selectedItems.add(true);
    }
  }

  void fetchCoinData() async {
    final userDataSnapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    availableCoins = userDataSnapshot.get('coins');
  }

  void calculateSubtotal() {
    double tempSubtotal = 0.0;

    for (int i = 0; i < priceAfterDiscount.length; i++) {
      double price = priceAfterDiscount[i].toDouble();
      int quantity = cartItemQuantities[i];
      tempSubtotal += price * quantity;
    }

    setState(() {
      subTotal = tempSubtotal;
      total = subTotal; // + delivery charge
    });

    setState(() {
      isLoading = false;
    });
  }

  void getPromoDiscountMoney() async {
    final promoSnapshot = await FirebaseFirestore
        .instance
        .collection('Promo Codes')
        .doc(promoCode).get();

    promoDiscount = promoSnapshot['discount'].toDouble();
    promoDiscountMoney = ( subTotal / 100) * promoDiscount ;
    setState(() {
      total = total - promoDiscountMoney;
    });
  }

  Future<void> deleteDocument(int index) async {
    setState(() {
      isDeleting = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection(
          '/userData/${FirebaseAuth.instance.currentUser!.uid}/Cart')
          .doc(cartDocumentIds[index])
          .delete();

      setState(() {
        // Remove the deleted document from the list
        cartDocumentIds.removeAt(index);
      });
    } catch (error) {
      const Text('Error Deleting Cart Item');
    } finally {
      setState(() {
        isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController promoController = TextEditingController();
    TextEditingController coinController = TextEditingController();

    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 0)), (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        body: SizedBox(
          child: FirebaseAuth.instance.currentUser == null ?
              //Login
          Padding(
            padding: MediaQuery.of(context).size.width >= 600 ?
            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.3) :
            const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: SizedBox()),
                const Text(
                  'StormyMart',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Login to access the cart',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
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
                      /*Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                      );*/
                      Get.to(
                        BottomBar(bottomIndex: 3),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: const Text(
                      'Go to Login Page',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          )
              :
          isLoading ? Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: const LinearProgressIndicator(),
            ),
          ) :
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Space
                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),

                      //Cart text
                      const Text(
                        'My Cart',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      //Space
                      const SizedBox(height: 30,),

                      //Cart
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DeliveryContainer(),

                            //Space
                            const SizedBox(height: 10,),

                            //Cart items
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //number of items
                                  Text(
                                    '${cartItemIds.length.toString()} items',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),

                                  //items
                                  if(cartItemIds.isNotEmpty)...[
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: isDeleting ?
                                      const Center(
                                        child: LinearProgressIndicator(),
                                      ) :
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: cartItemIds.length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: 170,
                                            width: double.infinity,
                                            child: Card(
                                              elevation: 0,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  //Image
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                          ProductScreen(productId: cartItemIds[index]),
                                                          transition: Transition.fade
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 10),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width*0.38 - 25,//0.40, 0.38 - 25 0.32 - 10
                                                        height: 124, //137 127 120
                                                        decoration: BoxDecoration(
                                                          /*border: Border.all(
                                                                width: 0, //4
                                                                color: Colors.transparent
                                                            ),*/
                                                            borderRadius: BorderRadius.circular(20)
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(15),
                                                          child:  /*Image.network(
                                                            productImages[index],
                                                            fit: BoxFit.cover,
                                                          )*/FadeInImage.memoryNetwork(
                                                            image: productImages[index],
                                                            placeholder: kTransparentImage,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //Texts
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width*0.45 - 10,//200,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        //Title
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 23),
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
                                                            'Price: ${priceAfterDiscount[index]} BDT',
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
                                                            'Size: ${cartItemSizes[index]}',
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
                                                            'Variant: ${cartItemVariants[index]}',
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
                                                            'Quantity: ${cartItemQuantities[index]}',
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

                                                  //Delete
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return  AlertDialog(
                                                            title: const Text('Please Confirm'),
                                                            content: const Text('Are you sure you want to delete this item?'),
                                                            actions: [
                                                              // The "Yes" button
                                                              TextButton(
                                                                  onPressed: () {
                                                                    deleteDocument(index);
                                                                    Navigator.of(context).push(
                                                                        MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 2),)
                                                                    );
                                                                  },
                                                                  child: const Text('Yes')
                                                              ),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    // Close the dialog
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: const Text('No'))
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const SizedBox(
                                                      child: Icon(
                                                        Icons.delete_forever,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ]
                                  else...[
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          'Nothing to Show',
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Calculation
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItemIds.length,
                        itemBuilder: (context, index) {

                          return Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Title * Quantity
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.45 - 20,
                                  child: Text(
                                    productTitles[index],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                Text('${priceAfterDiscount[index].toStringAsFixed(0)}× ${cartItemQuantities[index]}'),
                                // = Price
                                Text('${priceAfterDiscount[index] * cartItemQuantities[index]}')
                              ],
                            ),
                          );
                        },
                      ),

                      //Dotted Divider Line
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 1.0,
                          dashLength: 4.0,
                          dashColor: Colors.grey,
                          //dashGradient: [Colors.red, Colors.blue],
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          //dashGapGradient: [Colors.red, Colors.blue],
                          dashGapRadius: 0.0,
                        ),
                      ),

                      //Subtotal Line
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
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
                            ),
                          ],
                        ),
                      ),

                      //Coins Line
                      Padding(
                        padding: const EdgeInsets.only(top: 5,left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('You Have ',),
                            Text(
                              '$availableCoins',//${userDatasnapshot.data!.get('coins')}
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.amber,
                              ),
                            ),
                            const Text(' available COINS to use',)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            //TextBox
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6,
                              height: 50,
                              child: TextField(
                                onChanged: (value) {
                                  inputCoinAmount = double.parse(value);
                                },
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                                decoration: InputDecoration(
                                  hintText: "INPUT COIN AMOUNT",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade500,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: const Icon(Icons.money, color: Colors.amber,),
                                ),
                                keyboardType: TextInputType.number,
                                controller: coinController,
                              ),
                            ),
                            //Space
                            const SizedBox(width: 10,),
                            //Button
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width*0.30,
                              child: ElevatedButton(
                                onPressed: () {
                                  if(inputCoinAmount <= availableCoins){
                                    setState(() {
                                      coinDiscount = inputCoinAmount / 1000;
                                      total = total - coinDiscount;
                                    });
                                  }
                                  else{
                                    ScaffoldMessenger
                                        .of(context)
                                        .showSnackBar(
                                        const SnackBar(
                                            content: Text('More than available coins')
                                        )
                                    );
                                  }
                                },
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.amber)
                                ),
                                child: const Text('Redeem Coin'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(coinDiscount != 0.0)...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 5),
                                child: Text(
                                    'Coin Discount for $inputCoinAmount coins is : '
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, right: 5),
                                child: Text(
                                  '- $coinDiscount',
                                  style: const TextStyle(
                                      color: Colors.red
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],

                      //Promo Text
                      const Padding(
                        padding: EdgeInsets.only(top: 5,left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Use Promo Code to get extra discount',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Promo Code
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            //TextBox
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6,
                              height: 50,
                              child: TextField(
                                onChanged: (value) {
                                  promoCode = value;
                                },
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                                decoration: InputDecoration(
                                  hintText: "PROMO CODE",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade500,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.discount,
                                    color: Colors.green,
                                  ),
                                ),
                                controller: promoController,
                              ),
                            ),
                            //Space
                            const SizedBox(width: 10,),
                            //Button
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width*0.30,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('Promo Codes')
                                      .where(FieldPath.documentId, isEqualTo: promoCode)
                                      .get()
                                      .then((querySnapshot) async {
                                    if (querySnapshot.size > 0) {
                                      getPromoDiscountMoney();
                                      setState(() {
                                        isPromoCodeFound = true;
                                      });
                                    } else {
                                      setState(() {
                                        isPromoCodeFound = false;
                                      });
                                    }
                                  });
                                },
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(Colors.green)
                                ),
                                child: const Text('Apply Code'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Promo Discount Money
                      if(isPromoCodeFound == true)...[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Promo Discount ${promoDiscount.toString()}%'
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  '- ${promoDiscountMoney.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                      color: Colors.red
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                      else...[
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 15),
                          child: Row(
                            children: [
                              Text(
                                'Promo Code Not Found',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(child: SizedBox())
                            ],
                          ),
                        ),
                      ],

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

                      //Total
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                'Total'
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                total.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.5
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      //Check Out Button
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: isLoading ? LinearProgressIndicator(
                                  color: Colors.green.shade300,
                                  backgroundColor: Colors.green.shade100,
                                )
                                    :
                                ElevatedButton(
                                  onPressed: (){
                                    Get.to(
                                      CheckOut(
                                        usedCoins: inputCoinAmount,
                                        coinDiscount: coinDiscount,
                                        usedPromoCode: promoCode,
                                        itemsTotal: total,
                                        promoDiscount: promoDiscountMoney,
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(Colors.green)
                                  ),
                                  child: const Text(
                                    'Proceed to Check Out',
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

                      const  SizedBox(
                        height: 100,
                      )
                    ]
                )
            ),
          ),
        ),
      ),
    );
  }
}