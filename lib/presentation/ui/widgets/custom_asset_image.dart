import 'package:flutter/material.dart';

class CustomAssetImage extends StatelessWidget {
  final String path;
  final double height;
  const CustomAssetImage({super.key, required this.path, this.height = 236});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: height,
      child: Image(image: AssetImage(path)),
    );
  }
}
