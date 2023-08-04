import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:stormymart/Components/custom_image.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('Banners').get(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          List<String> images = [];
          for(int i =0; i<snapshot.data!.docs.length; i++){
            images.add(snapshot.data?.docs[i]['image']);
          }
          return Padding(
            padding: const EdgeInsets.only(right: 0, left: 0, top: 10),
            child: SizedBox(
              //margin: const EdgeInsets.only(top: 15,left: 15, right: 15, bottom: 15),
              width: MediaQuery.of(context).size.width*1,//150, 0.38
              height: 181,//137
              /*decoration: BoxDecoration(
              border: Border.all(
                  width: 4,
                  color: Colors.black12
              ),
              borderRadius: BorderRadius.circular(20)
              ),*/
              child: images.isNotEmpty ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ImageSlideshow(
                  //width: 200, //double.infinity,
                    height: 200, //MediaQuery.of(context).size.height * 0.45,
                    initialPage: 0,
                    indicatorColor: Colors.amber,
                    indicatorBackgroundColor: Colors.grey,
                    onPageChanged: (value) {},
                    autoPlayInterval: 3500,
                    isLoop: true,
                    children: List.generate(images.length, (index) {
                      return CustomImage(
                        images[index],
                        radius: 10,
                        height: 200,
                        //fit: BoxFit.cover,
                      );
                    })
                ),
              ) :
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'https://cdn.dribbble.com/users/256646/screenshots/17751098/media/768417cc4f382d6171053ad620bc3c3b.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const LinearProgressIndicator();
        }
        else{
          return const Center(
            child: Text(
              'Nothing Found',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildPageIndicator(int imageLength, int selectedIndex) {
    List<Widget> list = [];
    for (int i = 0; i < imageLength; i++) {
      list.add(i == selectedIndex ? _indicator(true) : _indicator(false));
    }
    return Container(
      height: 181,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        height: 4.0,
        width: isActive ? 16 : 4.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: isActive ? const Color(0XFF101010) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
