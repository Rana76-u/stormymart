import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Profile/profile.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                )
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: const Icon(
              Icons.arrow_back_rounded
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              const Text(
                'About this app',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  fontSize: 25
                ),
              ),

              const SizedBox(height: 20,),

              const Text(
                'StormyMart is your go-to e-commerce marketplace app, '
                    'offering a seamless and personalized shopping experience. '
                    'Discover a vast array of products from trusted vendors, '
                    'powered by advanced machine learning for tailored recommendations. '
                    'Enjoy a sleek and intuitive user interface, lightning-fast search, and secure checkout. '
                    'Earn rewards with StormyPoints and track your orders with ease. Elevate your shopping journey with StormyMart, '
                    'your ultimate destination for all things shopping!',
                style: TextStyle(
                    fontFamily: 'Urbanist',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
