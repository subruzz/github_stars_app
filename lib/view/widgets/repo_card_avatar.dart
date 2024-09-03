import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:github_starts_app/view/widgets/shimmer_avatar.dart';

import '../../utils/constants/ui_constants.dart';

class RepoCard extends StatelessWidget {
  final String avatarUrl;

  const RepoCard({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        width: kRadius30 * 2,
        height: kRadius30 * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircleAvatar(
          backgroundColor: Colors.white,
          radius: kRadius30,
          child: ShimmerPlaceholder(radius: kRadius30),
        ),
        errorWidget: (context, url, error) => const CircleAvatar(
          radius: kRadius30,
          backgroundColor: Colors.white,
          child: Icon(Icons.error),
        ),
      ),
    );
  }
}
