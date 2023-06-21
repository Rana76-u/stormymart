import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
              onPressed: () {
                setState(() {
                  isLoading = true;
                });

                Authservice().signInWithGoogle();

                Authservice().handleAuthState();

                setState(() {
                  isLoading = false;
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
          isLoading ? AlertDialog(
              content: SizedBox(
                width: 200.0,
                height: 200.0,
                child: Lottie.network(
                  'https://assets6.lottiefiles.com/packages/lf20_heoa8x46.json',
                  fit: BoxFit.cover,
                ),
              )
          ): const SizedBox(),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
