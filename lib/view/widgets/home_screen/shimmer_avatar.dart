import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/constants/ui_constants.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double radius;

  const ShimmerPlaceholder({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kShimmerBaseColor,
      highlightColor: kShimmerHighlightColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: Icon(Icons.image, color: kShimmerIconColor, size: radius),
      ),
    );
  }
}
