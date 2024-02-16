import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart/Blocks/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:stormymart/Blocks/Bottom%20Navigation%20Bloc/bottom_navigation_states.dart';
import 'package:stormymart/Screens/Cart/cart_loginpage.dart';
import 'package:stormymart/Screens/Search/search.dart';
import 'package:stormymart/utility/globalvariable.dart';
import '../Blocks/Bottom Navigation Bloc/bottom_navigation_events.dart';
import '../Screens/Cart/cart.dart';
import '../Screens/Home/home.dart';
import '../Screens/Profile/profile.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  int bottomIndex = 0;
  BottomBar({Key? key, required this.bottomIndex}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int previousIndex = -1;

  @override
  Widget build(BuildContext context){
    return BlocConsumer<BottomBarBloc, BottomBarState>(
        listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: state.currentIndex == 0
                ? const HomePage()
                : state.currentIndex == 1
                ? SearchPage(keyword: keyword,)
                : state.currentIndex == 2
                ? FirebaseAuth.instance.currentUser != null ? Cart() : const CartLoginPage()
                : const Profile(),
          ),
          //child: _options[widget.bottomIndex],
          bottomNavigationBar: FlashyTabBar(
            animationCurve: Curves.linear,
            selectedIndex: state.currentIndex,//widget.bottomIndex,
            iconSize: 30,
            showElevation: false, // use this to remove appBar's elevation
            onItemSelected: (index) {
              final provider = BlocProvider.of<BottomBarBloc>(context);
              provider.add(IndexChange(currentIndex: index));
            },
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
      },
    );
  }
}
