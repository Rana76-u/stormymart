import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Home/hot_deals.dart';

class ShowAllHotDeals extends StatelessWidget {
  const ShowAllHotDeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Deals'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
          child: HotDeals()
      ),
    );
  }
}
