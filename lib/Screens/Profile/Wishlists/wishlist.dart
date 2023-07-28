import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Profile/Wishlists/wishlist_body.dart';
import 'package:stormymart/Screens/Profile/Wishlists/wishlist_top.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WishListTop(),

            SizedBox(height: 30,),

            WishListBody()
          ],
        ),
      ),
    );
  }
}
