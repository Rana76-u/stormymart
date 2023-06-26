import 'package:flutter/material.dart';

import '../../utility/bottom_nav_bar.dart';

class CartLoginPage extends StatefulWidget {
  const CartLoginPage({super.key});

  @override
  State<CartLoginPage> createState() => _CartLoginPageState();
}

class _CartLoginPageState extends State<CartLoginPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: SizedBox()),
            const Text(
              'StormyMart',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Login to access the cart',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Urbanist'
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),));
                },
                child: const Text(
                  'Go to Login Page',
                  style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

