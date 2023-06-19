import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Search/search.dart';
import '../Screens/Cart/cart.dart';
import '../Screens/Home/home.dart';
import '../Screens/Profile/profile.dart';

class BottomBar extends StatefulWidget {
  int bottomIndex = 0;
  BottomBar({Key? key, required this.bottomIndex}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int previousIndex = -1;

  Widget? check(){
    if(widget.bottomIndex == 0){
      previousIndex = 0;
      return const HomePage();
    }else if(widget.bottomIndex == 1){
      previousIndex = 1;
      return const SearchPage(); //ShopHomePage
    }else if(widget.bottomIndex == 2){
      previousIndex = 2;
      return const Cart(); //Main screen Buy & Sell will be here
    }else if(widget.bottomIndex == 3){
      previousIndex = 3;
      return const Profile();
    }
    return null;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: check(),
      ),
      //child: _options[widget.bottomIndex],
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: widget.bottomIndex,
        iconSize: 30,
        showElevation: false, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          widget.bottomIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home_rounded),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.search),
            title: const Text('Search'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Account'),
          ),
        ],
      ),
    );
  }
}
