import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Home/gridview.dart';
import 'package:stormymart/Screens/Home/horizontal_category.dart';
import 'package:stormymart/Screens/Home/hot_deals.dart';
import 'package:stormymart/Screens/Home/imageslider.dart';
import 'package:stormymart/Screens/Home/recommanded_for_you.dart';
import 'package:stormymart/utility/auth_service.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';


import '../../Components/searchfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            //Electronics
            const ExpansionTile(
              iconColor: Colors.amber,
              textColor: Colors.amber,
              title: Text('Electronics'),
              leading: Icon(Icons.electric_bolt),
              childrenPadding: EdgeInsets.only(left: 40),
              children: [
                ExpansionTile(
                  iconColor: Colors.grey,
                  textColor: Colors.grey,
                  title: Text("Laptop"),
                  leading: Icon(Icons.laptop),
                  childrenPadding: EdgeInsets.only(left: 40),
                  children: [
                    ListTile(
                      title: Text("Asus"),
                    ),
                    ListTile(
                      title: Text("Apple"),
                    ),
                    ListTile(
                      title: Text("Hp"),
                    ),
                    ListTile(
                      title: Text("Samsung"),
                    ),
                  ],
                ),
                ListTile(
                  title: Text("Phone"),
                  leading: Icon(Icons.phone_iphone_outlined),
                ),
                ListTile(
                  title: Text("Headphones"),
                  leading: Icon(Icons.headphones),
                ),
              ],
            ),
            //Home Appliances
            const ExpansionTile(
              iconColor: Colors.amber,
              textColor: Colors.amber,
              title: Text('Home Appliances'),
              leading: Icon(Icons.home_work_outlined),
              childrenPadding: EdgeInsets.only(left: 60),
              children: [
                ListTile(
                  title: Text("Kitchen"),
                  leading: Icon(Icons.kitchen),
                ),
                ListTile(
                  title: Text("Bedroom"),
                  leading: Icon(Icons.bed),
                ),
                ListTile(
                  title: Text("Interior"),
                  leading: Icon(Icons.interests),
                ),
              ],
            ),
          ],
        ),
      ),
      body: CustomScrollView(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  GestureDetector(
                    onTap: () {
                      Authservice().signOut();
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
        RecommandedForYouTitle(),
        SizedBox(height: 10,),
        MostPupularCategory(),
        RecommandedForYou(),
        SizedBox(height: 100,)
      ],
    );
  }
}
