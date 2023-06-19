import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Home/gridview.dart';
import 'package:stormymart/Screens/Home/header.dart';
import 'package:stormymart/Screens/Home/horizontal_category.dart';
import 'package:stormymart/Screens/Home/imageslider.dart';

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
          SliverPadding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.035),
            sliver: const SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              flexibleSpace: HomePageHeader(),
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
        SearchField(),
        SizedBox(height: 10,),
        ImageSlider(),
        SizedBox(height: 10,),
        GridViewPart(),
        SizedBox(height: 10,),
        MostPupularCategory()
      ],
    );
  }
}
