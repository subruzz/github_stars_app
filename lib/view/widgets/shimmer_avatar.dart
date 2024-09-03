import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double radius;

  const ShimmerPlaceholder({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: Icon(Icons.image, color: Colors.grey[400], size: radius),
      ),
    );
  }
}
