import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:stormymart/Screens/Chat%20Screen/chat_screen.dart';
import 'package:stormymart/Screens/Home/carousel_slider.dart';
import 'package:stormymart/Screens/Home/horizontal_category.dart';
import 'package:stormymart/Screens/Home/hot_deals.dart';
import 'package:stormymart/Screens/Home/imageslider.dart';
import 'package:stormymart/Screens/Home/recommanded_for_you.dart';
import 'package:stormymart/Screens/Profile/Coins/coins.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';
import 'package:stormymart/utility/globalvariable.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Search/search.dart';

/*class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

}*/

class HomePage extends StatelessWidget {
  const HomePage({super.key});

/*  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    await Permission.storage.request();

//this type of marked are one that that was commented before /**/ this on happened
    //if(!status.isGranted){}

    //var status1 = await Permission.manageExternalStorage.status;
    // if(!status1.isGranted){
    //   await Permission.manageExternalStorage.request();
    // }
  }*/

/*  Future<void> _handleRefresh() async {
    await Permission.storage.request();
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
  }*/

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(left: 10, right: 10);
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: _drawer(context),
        body: CustomScrollView( //RefreshIndicator just above here
          slivers: <Widget>[
            _appbar(context),

            //build body
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

  Widget _drawer(BuildContext context){
    return Drawer(
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
                            child: FadeInImage.memoryNetwork(
                              image: FirebaseAuth.instance.currentUser!.photoURL ??
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgBhcplevwUKGRs1P-Ps8Mwf2wOwnW_R_JIA&usqp=CAU',
                              placeholder: kTransparentImage,
                            ),
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
                ]
                else...[
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      onPressed: () {
                        //open login page
                        Get.to(
                            BottomBar(bottomIndex: 3),
                            transition: Transition.fade
                        );
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
                              /*Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 1),)
                                          );*/
                              Get.to(
                                SearchPage(keyword: keyword),
                                transition: Transition.fade,
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
    );
  }

  Widget _appbar(BuildContext context){
    return SliverAppBar(
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
                /*Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          )
                        );*/
                if(FirebaseAuth.instance.currentUser != null){
                  Get.to(
                    ChatScreen(),
                    transition: Transition.fade,
                  );
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You'r Not Logged In."))
                  );
                }
              },
              child: const Icon(
                MingCute.comment_2_line,
              ),
            ),

            //coin icon
            GestureDetector(
              onTap: () {
                Get.to(
                  const Coins(),
                  transition: Transition.fade,
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  MingCute.copper_coin_line,
                  color: Colors.yellow,
                ), /*Text(
                  "🪙",
                  style: TextStyle(
                    fontSize: 22.5,
                  ),
                )*/
              )
              //Discontinued due to performance lag issue
              /*Image.asset(
                        'assets/lottie/gold-coin.gif',
                        height: 60,
                      )*/,
            ),
          ],
        ),
        //flexibleSpace: HomePageHeader(),
      );
  }

  Widget _buildBody(BuildContext context){
    return Padding(
      padding: MediaQuery.of(context).size.width >= 600 ?
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05) :
      const EdgeInsets.symmetric(horizontal: 0), //EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1)
      child: const Column(
        children: [
          /*SizedBox(height: 10,),
          SearchField(),
          SizedBox(height: 10,),*/
          ImageSlider(),
          SizedBox(height: 10,),
          //Replace with Carosoul
          //GridViewPart(),
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: Column(
              children: [
                HorizontalSlider(),
                SizedBox(height: 10,),
                HotDealsTitle(),
                HotDeals(),
                RecommendedForYouTitle(),
                SizedBox(height: 10,),
                //MostPopularCategory(),
                RecommendedForYou(),
              ],
            ),
          ),
          SizedBox(height: 100,)
        ],
      ),
    );
  }
}

