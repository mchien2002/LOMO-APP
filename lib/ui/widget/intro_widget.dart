import 'package:flutter/material.dart';

class IntroItem extends StatelessWidget {
  final String imageUrl;

  const IntroItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: ClipRRect(
        child: Material(
          elevation: 4.0,
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
