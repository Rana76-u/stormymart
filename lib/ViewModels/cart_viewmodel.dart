import 'package:cloud_firestore/cloud_firestore.dart';

class CartViewModel {

  /*Future<void> initFunctions(BuildContext context, String uid) async {
    final provider = BlocProvider.of<CartBloc>(context);

    List cartItemIds = [];
    List allProductDocIds = [];
    List cartDocumentIds = [];
    List cartItemVariants = [];
    List priceAfterDiscount = [];
    List cartItemQuantities = [];

    try {
      // Fetching product documents
      final querySnapshot =
      await FirebaseFirestore.instance.collection('/Products').get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        allProductDocIds.add(documentSnapshot.id);

        provider.add(AddAllProductDocIds(id: documentSnapshot.id));
      }

      // Fetching cart items
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .collection('Cart')
          .get();

      for (var doc in cartSnapshot.docs) {
        cartItemIds.add(doc['id']);
        cartDocumentIds.add(doc.id);
        cartItemVariants.add(doc['variant']);
        cartItemQuantities.add(doc['quantity']);

        provider.add(AddCartItemIds(item: doc['id']));
        provider.add(AddCartDocumentIds(item: doc.id));
        provider.add(AddCartItemSizes(size: doc['selectedSize']));
        provider.add(AddCartItemVariants(variant: doc['variant']));
        provider.add(AddCartItemQuantities(quantity: doc['quantity']));
      }

      // Fetching product details for each cart item
      for (int i = 0; i < cartItemIds.length; i++) {
        if (allProductDocIds.contains(cartItemIds[i].trim())) {
          final productSnapshot = await FirebaseFirestore.instance
              .collection('/Products')
              .doc(cartItemIds[i].trim())
              .get();

          provider.add(AddProductTitles(item: productSnapshot.get('title')));
          provider.add(AddProductPrices(item: productSnapshot.get('price')));
          provider.add(AddProductQuantityAvailable(item: productSnapshot.get('quantityAvailable')));
          provider.add(AddProductDiscounts(discount: productSnapshot.get('discount')));

          double tempPrice = (productSnapshot.get('price') / 100) * (100 - productSnapshot.get('discount'));
          priceAfterDiscount.add(tempPrice);

          provider.add(AddPriceAfterDiscount(price: tempPrice));
        } else {
          // If product is not available, remove it from the cart
          FirebaseFirestore.instance
              .collection('userData')
              .doc(uid)
              .collection('Cart')
              .doc(cartDocumentIds[i].trim())
              .delete();
          provider.add(RemoveCartItemIds(index: i));
          provider.add(RemoveCartDocumentIds(index: i));
        }

        // Fetching product images for each cart item
        final productSnapshot = await FirebaseFirestore.instance
            .collection('/Products/${cartItemIds[i]}/Variations')
            .doc(cartItemVariants[i])
            .get();

        provider.add(AddProductImages(image: productSnapshot.get('images')[0]));

        // Setting selected items
        provider.add(AddSelectedItems(item: true));
      }


      // Calculating subtotal
      double tempSubtotal = 0.0;
      for (int i = 0; i < priceAfterDiscount.length; i++) {
        double price = priceAfterDiscount[i].toDouble();
        int quantity = cartItemQuantities[i];
        tempSubtotal += price * quantity;
      }
      double subTotal = tempSubtotal;

      // Fetching user coin data
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();
      provider.add(AvailableCoins(availableCoins: userDataSnapshot.get('coins')));

      // Updating total and subtotal
      provider.add(Subtotal(subtotal: subTotal));
      provider.add(Total(total: subTotal));

      provider.add(IsLoading(isLoading: false));
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }

  Future<void> deleteDocument(int index, BuildContext context, String uid) async {
    final provider = BlocProvider.of<CartBloc>(context);
    final cartState = provider.state;
    provider.add(IsDeleting(isDeleting: true));

    try {
      await FirebaseFirestore.instance
          .collection(
          '/userData/$uid/Cart')
          .doc(cartState.cartDocumentIds[index])
          .delete();

      provider.add(RemoveCartDocumentIds(index: index));
      *//*setState(() {
        // Remove the deleted document from the list
        cartDocumentIds.removeAt(index);
      });*//*
    } catch (error) {
      const Text('Error Deleting Cart Item');
    } finally {
      provider.add(IsDeleting(isDeleting: false));
      *//*setState(() {
        isDeleting = false;
      });*//*
    }
  }*/

  Future<bool> checkIfCartItemExists(String cartItemId) async {
    String documentId = 'sdfjkldsfhjisdfkjhh';
    CollectionReference productsCollection = FirebaseFirestore.instance.collection('Products');

    try {
      DocumentSnapshot<Object?> querySnapshot = await productsCollection.doc(documentId).get();
      if (querySnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

}