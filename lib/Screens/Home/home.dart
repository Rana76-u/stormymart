import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Home/gridview.dart';
import 'package:stormymart/Screens/Home/horizontal_category.dart';
import 'package:stormymart/Screens/Home/hot_deals.dart';
import 'package:stormymart/Screens/Home/imageslider.dart';
import 'package:stormymart/Screens/Home/recommanded_for_you.dart';

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
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverPadding(
            padding: EdgeInsets.all(0),
            sliver: SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              leading: Icon(Icons.menu, color: Colors.black),
              title: Text(
                'StormyMart',
                style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist'
                ),
                textAlign: TextAlign.start,
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
          /*SliverPadding(
            padding: padding,
            sliver: _buildPopulars(),
          ),*/
          const SliverAppBar(
              flexibleSpace: SizedBox(height: 24),
            backgroundColor: Colors.white,
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
      ],
    );
  }
}
