import 'package:flutter/material.dart';
import '../styles/colors.dart';

class Artistcard extends StatelessWidget {
  final String imageUrl;
  final String name;
  const Artistcard({super.key, required this.imageUrl, required this.name});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 35, backgroundImage: NetworkImage(imageUrl)),
          SizedBox(height: 5,),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color:AppColors.font,
            ),
          ),
        ],
      ),
    );
  }
}
