import 'package:flutter/material.dart';
import '../styles/colors.dart';

class Songcard extends StatelessWidget {
  final String imageUrl;
  final String songName;
  final String artistName;

  const Songcard({
    super.key,
    required this.artistName,
    required this.imageUrl,
    required this.songName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.grey.shade200,
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              imageUrl,
              // width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),

          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                songName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.subfont,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                artistName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.font,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
