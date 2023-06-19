import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MostPupularCategory extends StatefulWidget {
  const MostPupularCategory({super.key});

  @override
  State<MostPupularCategory> createState() => _MostPupularCategoryState();
}

class _MostPupularCategoryState extends State<MostPupularCategory> {

  List<List<dynamic>> dataSets = [];
  int lengthOfFields = 0;
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: FirebaseFirestore.instance.collection('/Category').doc('Search Recommandation').get(),
          builder: (context, snapshot) {

            final data = snapshot.data!.data();
            lengthOfFields = data!.length;

            data!.forEach((key, value) {
              if(value is List){
                List<dynamic> row = value.cast<dynamic>();
                dataSets.add(row);
              }
            });
            if(snapshot.hasData){
              return _buildBody();
            }
            else if(snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            else{
              return const Center(
                child: Text(
                  'Nothing Found',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SizedBox(
      height: 47,//38
      child: ListView.separated(
        itemCount: lengthOfFields,
        scrollDirection: Axis.horizontal,
        itemBuilder: _buildItem,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 12);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final data = dataSets[index];

    final isActive = _selectIndex == index;
    const radius = BorderRadius.all(Radius.circular(9)); //19
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: isActive ? Colors.amber.shade400 : Colors.grey.shade200, width: 2),
        color: isActive ? Colors.amber.shade400 : const Color(0xFFFFFFFF),
      ),
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: radius,
        onTap: () => _onTapItem(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    data[1],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 7,),
              Text(
                data[0],
                style: TextStyle(
                  color: isActive ? const Color(0xFFFFFFFF) : Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  // user interact the item of special offers.
  void _onTapItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }
}

class MostPopularTitle extends StatelessWidget {
  const MostPopularTitle({
    Key? key,
    required this.onTapseeAll,
  }) : super(key: key);

  final Function onTapseeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Most Popular', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF212121))),
        TextButton(
          onPressed: () => onTapseeAll(),
          child: const Text(
            'See All',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF212121),
            ),
          ),
        ),
      ],
    );
  }
}
