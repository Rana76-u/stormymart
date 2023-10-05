import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stormymart/Screens/Search/search.dart';

class HorizontalSlider extends StatelessWidget {
  const HorizontalSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: (){
              Get.to(
                SearchPage(keyword: 'Watch',),
                transition: Transition.rightToLeft
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: Card(
                //margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                child: const Center(
                  child: Text(
                    'Watch',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              Get.to(
                  SearchPage(keyword: 'Trimmer',),
                  transition: Transition.rightToLeft
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: Card(
                //margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                child: const Center(
                  child: Text(
                    'Trimmer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              Get.to(
                  SearchPage(keyword: 'Home Appliances',),
                  transition: Transition.rightToLeft
              );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: Card(
                //margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                child: const Center(
                  child: Text(
                    'Home Appliances',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

