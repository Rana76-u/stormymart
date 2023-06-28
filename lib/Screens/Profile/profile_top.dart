import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stormymart/Screens/Profile/profile_accountinfo.dart';

class ProfileTop extends StatefulWidget {
  const ProfileTop({super.key});

  @override
  State<ProfileTop> createState() => _ProfileTopState();
}

class _ProfileTopState extends State<ProfileTop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //BG Image
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.29,
          child: Image.asset(
            'assets/images/orange_abstract_bg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        //Infos
        Positioned(
          height: 50,
          width: MediaQuery.of(context).size.width,
          top: MediaQuery.of(context).size.height*0.1,
          left: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Profile Photo
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  FirebaseAuth.instance.currentUser!.photoURL.toString(),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20,),
              //Texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: SizedBox()),
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              const SizedBox(width: 50,),
              //Settings Icons
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AccountInfo(),)
                  );
                },
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        //Three items
        Positioned(
          top: MediaQuery.of(context).size.height*0.21,
          left: MediaQuery.of(context).size.height*0.07,
          right: MediaQuery.of(context).size.height*0.07,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //wishlist
              Column(
                children: [
                  Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Wishlist',
                    style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Urbanist'
                    ),
                  )
                ],
              ),
              //Coupons
              Column(
                children: [
                  Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Coupons',
                    style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Urbanist'
                    ),
                  )
                ],
              ),
              //Points
              Column(
                children: [
                  Text(
                    '500',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Coins',
                    style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'Urbanist'
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
