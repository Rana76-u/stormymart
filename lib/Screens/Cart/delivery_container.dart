import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DeliveryContainer extends StatelessWidget {
  const DeliveryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.blue.withOpacity(0.2),
        ),
        height: 100 ,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_jmejybvu.json',
                height: 80,
                width: 80
            ),
            const SizedBox(width: 10,),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: SizedBox()),
                Text(
                  'Cash on Delivery',
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  'Tentative Arrival, Jun, 22 - Jun, 23',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.bold
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            )
          ],
        ),
      );
  }
}
