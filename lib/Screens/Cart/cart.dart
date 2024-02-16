import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:stormymart/Blocks/Cart%20Bloc/cart_events.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../Blocks/Cart Bloc/cart_bloc.dart';
import '../../Blocks/Cart Bloc/cart_states.dart';
import '../../ViewModels/cart_viewmodel.dart';
import '../../utility/bottom_nav_bar.dart';
import '../Product Screen/product_screen.dart';
import 'delivery_container.dart';

class Cart extends StatelessWidget {
  Cart({super.key});

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 0)),
            (route) => false);
      },
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'My Cart',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: floatingButtonWidget(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
                      cartItems(state),
                      const SizedBox(
                        height: 150,
                      )
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget floatingButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            label: const Text(
              'Total: 1540/-, Proceed to Checkout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            icon: const Icon(Icons.sell_rounded),
          ),
        ),
      ),
    );
  }

  Widget cartItems(CartState state) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .collection('Cart')
          .get(),
      builder: (context, cartSnapshot) {
        if (cartSnapshot.hasData) {
          final provider = BlocProvider.of<CartBloc>(context);
          int numberOfItem = cartSnapshot.data!.docs.length;

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DeliveryContainer(),

                //Space
                const SizedBox(
                  height: 10,
                ),

                numberOfItemsWidget(numberOfItem),

                Checkbox(
                    value: state.isAllSelected,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    onChanged: (value) {
                      if(state.checkList.isEmpty){
                        for(int i=0; i<numberOfItem; i++){
                          provider.add(AddCheckList(isChecked: false));
                        }
                      }
                      provider.add(SelectAllCheckList(isSelectAll: !state.isAllSelected));
                    },
                  ),

                //Cart items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: /*state.isDeleting ?
                      const Center(
                        child: LinearProgressIndicator(),
                      ) :*/
                        ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return checkIfProductExistsWidget(
                            cartSnapshot.data!.docs[index].id,
                            cartSnapshot.data!.docs[index].get('id'),
                            cartSnapshot.data!.docs[index].get('selectedSize'),
                            cartSnapshot.data!.docs[index].get('variant'),
                            cartSnapshot.data!.docs[index].get('quantity'),
                            index,
                            state,
                          numberOfItem
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (cartSnapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget(context, 0.4);
        } else {
          return errorWidget(context, 'Error Loading Data');
        }
      },
    );
  }

  Widget checkIfProductExistsWidget(String cartDocID, String productId,
      String size, String variant, int quantity, int index, CartState state, int numberOfItem) {
    return FutureBuilder<bool>(
      future: CartViewModel().checkIfCartItemExists(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget(context, 0.4); // or any loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool productExists = snapshot.data ?? false;
          if (productExists) {
            //delete the item
            return errorWidget(context, "Item Is Not Listed Anymore");
          } else {
            //below line was swaped
            return cartItemWidget(context, cartDocID, productId, size, variant,
                quantity, index, state, numberOfItem);
          }
        }
      },
    );
  }

  Widget cartItemWidget(
      BuildContext context,
      String cartDocID,
      String productId,
      String size,
      String variant,
      int quantity,
      int index,
      CartState state,
      int numberOfItem) {
    final provider = BlocProvider.of<CartBloc>(context);
    //provider.add(AddCheckList(isChecked: false));

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('/Products')
          .doc(productId.trim())
          .get(),
      builder: (context, productSnapshot) {
        if (productSnapshot.hasData) {
          /*provider.add(AddProductQuantityAvailable(item: productSnapshot.get('quantityAvailable')));
            provider.add(AddProductDiscounts(discount: productSnapshot.get('discount')));

            double tempPrice = (productSnapshot.get('price') / 100) * (100 - productSnapshot.get('discount'));
            provider.add(AddPriceAfterDiscount(price: tempPrice));*/

          return Card(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Checkbox
                Checkbox(
                  value: state.checkList.isNotEmpty
                      ? state.checkList[index]
                      : false,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onChanged: (value) {
                    if(state.checkList.isEmpty){
                      for(int i=0; i<numberOfItem; i++){
                        provider.add(AddCheckList(isChecked: false));
                      }
                    }

                    if(state.checkList[index] == true){
                      provider.add(UpdateIsSelected(isSelectAll: false));
                    }

                    provider.add(UpdateCheckList(
                        isChecked: state.checkList.isNotEmpty
                            ? !state.checkList[index]
                            : true,
                        index: index));
                  },
                ),

                //Image
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('/Products/$productId/Variations')
                      .doc(variant)
                      .get(),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            ProductScreen(productId: productId),
                            //transition: Transition.fade
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: 95,
                            height: 80, //137 127 120 124
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage.memoryNetwork(
                                image: imageSnapshot.data!.get('images')[0],
                                placeholder: kTransparentImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return loadingWidget(context, 0.4);
                    } else {
                      return errorWidget(context, 'Error Loading Data');
                    }
                  },
                ),

                //Texts
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55 -
                          20, //200, 0.45
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Title
                          Text(
                            productSnapshot.data!.get('title'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //Price
                          Text(
                            '৳ ${productSnapshot.data!.get('price')}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),

                          //Size
                          Text(
                            'Size: $size',
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis),
                          ),

                          //Variant
                          Text(
                            'Variant: $variant',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black54),
                          ),

                          //Quantity
                          Text(
                            'Quantity: $quantity',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //Delete
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Please Confirm'),
                            content: const Text(
                                'Are you sure you want to delete this item?'),
                            actions: [
                              // The "Yes" button
                              TextButton(
                                  onPressed: () {
                                    //CartViewModel().deleteDocument(index, context, uid);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          BottomBar(bottomIndex: 2),
                                    ));
                                  },
                                  child: const Text('Yes')),
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
                ),
              ],
            ),
          );
        } else if (productSnapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget(context, 0.4);
        } else {
          return errorWidget(context, 'Error Loading Data');
        }
      },
    );
  }

  /*ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {

                    //check if the cart added item still exists as a product or not
                    CartViewModel().checkIfCartItemExists(cartSnapshot.data!.docs[index].get('id'));

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          //Space
                          const SizedBox(height: 10,),

                          //Cart items
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                //items
                                if(
                                state.cartItemIds.isNotEmpty &&
                                    state.productImages.isNotEmpty &&
                                    state.productTitles.isNotEmpty &&
                                    state.priceAfterDiscount.isNotEmpty &&
                                    state.cartItemSizes.isNotEmpty &&
                                    state.cartItemVariants.isNotEmpty &&
                                    state.cartItemQuantities.isNotEmpty
                                )...[
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: state.isDeleting ?
                                    const Center(
                                      child: LinearProgressIndicator(),
                                    ) :
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.cartItemIds.length,
                                      itemBuilder: (context, index) {
                                        return cartItemCard(context,index, state);
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
                    );
                  },
                )*/

  Widget loadingWidget(BuildContext context, double size) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * size,
        child: const LinearProgressIndicator(),
      ),
    );
  }



  Widget errorWidget(BuildContext context, String text) {
    return Center(
      child: Text(text),
    );
  }

  Widget numberOfItemsWidget(int number) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        '$number items',
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
