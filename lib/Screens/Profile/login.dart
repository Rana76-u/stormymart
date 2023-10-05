import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';

import '../../utility/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SizedBox()),

          Lottie.asset('assets/lottie/google-logo.json'),
          const Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              'StormyMart',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              'Login / Signup',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Urbanist'
              ),
            ),
          ),
          const SizedBox(height: 7,),

          //Login Button
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              onPressed: () async{
                setState(() {
                  isLoading = true;
                });

               //await Authservice().signInWithGoogle();
                Authservice().signInWithGoogle().then((_) {
                  setState(() {
                    isLoading = false;
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 3),)
                    );
                  });
                })
                    .catchError((error) {
                  // Handle any error that occurred during sign-in
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error: $error')
                    )
                  );
                  setState(() {
                    isLoading = false;
                  });
                });
              },
              child: const Text(
                'Continue usign Google',
                style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                ),
              ),
            ),
          ),
          isLoading ? const LinearProgressIndicator(): const SizedBox(),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
