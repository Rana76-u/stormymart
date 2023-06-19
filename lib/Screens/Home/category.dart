import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  const Category(this.icon, this.title, this.id);

  final Icon icon;
  final String title;
  final String id;
}

final homeCategries = <Category>[
  const Category(Icon(Icons.laptop), 'Laptop', 'laptop'),
  const Category(Icon(Icons.phone_android_rounded), 'Phone', 'phone'),
  const Category(Icon(Icons.camera_alt_rounded), 'Camera', 'camera'),
  const Category(Icon(Icons.wallet), 'Wallet', 'wallet'),
  const Category(Icon(Icons.watch), 'Watch', 'watch'),
  const Category(Icon(Icons.kitchen), 'Kitchen', 'kitchen'),
  const Category(Icon(Icons.beach_access), 'Umbrella', 'umbrella'),
  const Category(Icon(Icons.sports), 'Sports', 'sports'),
];
