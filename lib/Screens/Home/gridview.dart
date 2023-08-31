import 'package:flutter/material.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';
import 'package:stormymart/utility/globalvariable.dart';

import 'category.dart';

class GridViewPart extends StatelessWidget {
  const GridViewPart({super.key});

  @override
  Widget build(BuildContext context) {

    late final List<Category> categories = homeCategries;

    return Expanded(
      flex: 0,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 100,
          mainAxisSpacing: 5,
          crossAxisSpacing: 24,
          maxCrossAxisExtent: 77,
        ),
        itemBuilder: ((context, index) {
          final data = categories[index];
          return GestureDetector(
            onTap: () {
              keyword = data.title;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 1),)
              );
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x10101014),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      data.icon.icon
                    ),//Image.asset(data.icon as String, width: 28, height: 28),
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  child: Text(
                    data.title,
                    style: const TextStyle(color: Color(0xff424242), fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
