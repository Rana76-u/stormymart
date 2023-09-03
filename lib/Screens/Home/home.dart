import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Chat%20Screen/chat_screen.dart';
import 'package:stormymart/Screens/Home/gridview.dart';
import 'package:stormymart/Screens/Home/horizontal_category.dart';
import 'package:stormymart/Screens/Home/hot_deals.dart';
import 'package:stormymart/Screens/Home/imageslider.dart';
import 'package:stormymart/Screens/Home/recommanded_for_you.dart';
import 'package:stormymart/Screens/Profile/Coins/coins.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';
import 'package:stormymart/utility/globalvariable.dart';


import '../../Components/searchfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> _handleRefresh() async {
    final navigator = Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BottomBar(bottomIndex: 0),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );

    // Simulate a delay for the refresh indicator
    await Future.delayed(const Duration(seconds: 1));

    // Reload the same page by pushing a new instance onto the stack
    navigator;
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(24, 0, 24, 0);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Color(0xFF0d1b2a)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(FirebaseAuth.instance.currentUser != null)...[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                            ),
                          ),
                          const SizedBox(width: 14,),
                          Text(
                            FirebaseAuth.instance.currentUser!.displayName ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: 'Urbanist'
                            ),
                          ),
                        ],
                      ),
                    )
                  ]else...[
                    SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        onPressed: () {
                          //open login page
                        },
                        child: const Text(
                          'Sign in using Google',
                          style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),
                        ),
                      ),
                    ),
                  ],
                  //const Expanded(child: SizedBox()),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Browse',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        'StormyMart',
                        style: TextStyle(
                            fontSize: 21,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            //Drawer items
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('/Category').doc('/Drawer').get(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  int length = snapshot.data!.data()!.keys.length;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: length,
                    itemBuilder: (context, index) {
                      String title = snapshot.data!.data()!.keys.elementAt(index);
                      List<dynamic> subCategories = snapshot.data!.get(title);
                      return ExpansionTile(
                        iconColor: Colors.amber,
                        textColor: Colors.amber,
                        title: Text(title),
                        childrenPadding: const EdgeInsets.only(left: 60),
                        children: List.generate(
                            subCategories.length,
                                (index) {
                                  return ListTile(
                                    title: Text(subCategories[index]),
                                    //leading: const Icon(Icons.kitchen),
                                      onTap: () {
                                        keyword = subCategories[index];
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 1),)
                                        );
                                      },
                                  );
                                },
                        ),
                      );
                    },
                  );
                }
                else if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                else{
                  return const Center(
                    child: Text('Nothings Here'),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(0),
              sliver: SliverAppBar(
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                pinned: true,
                title: Row(
                  children: [
                    //StormyMart
                    const Text(
                      'StormyMart',
                      style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist'
                      ),
                      textAlign: TextAlign.start,
                    ),

                    const Expanded(child: SizedBox()),

                    //chat icon
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          )
                        );
                      },
                      child: Icon(
                          Icons.chat_bubble_rounded,
                        color: Colors.grey.shade500,
                      ),
                    ),

                    //coin icon
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Coins(),)
                        );
                      },
                      child: Image.asset(
                          'assets/lottie/gold-coin.gif',
                        height: 60,
                      ),
                    ),
                  ],
                ),
                //flexibleSpace: HomePageHeader(),
              ),
            ),
            SliverPadding(
              padding: padding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  ((context, index) => _buildBody(context)),
                  childCount: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return const Column(
      children: [
        SizedBox(height: 10,),
        SearchField(),
        SizedBox(height: 10,),
        ImageSlider(),
        SizedBox(height: 10,),
        GridViewPart(),
        SizedBox(height: 10,),
        HotDealsTitle(),
        HotDeals(),
        RecommendedForYouTitle(),
        SizedBox(height: 10,),
        MostPupularCategory(),
        RecommendedForYou(),
        SizedBox(height: 100,)
      ],
    );
  }
}
