import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Blocks/Bottom Navigation Bloc/bottom_navigation_bloc.dart';
import '../../Blocks/Bottom Navigation Bloc/bottom_navigation_events.dart';

class CartLoginPage extends StatelessWidget {
  const CartLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  BlocProvider.of<BottomBarBloc>(context)
                      .add(IndexChange(currentIndex: 3));
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
      ),
    );
  }
}

