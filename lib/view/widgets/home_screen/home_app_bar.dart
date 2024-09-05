import 'package:flutter/material.dart';
import 'package:github_starts_app/utils/constants/ui_constants.dart';
import 'package:github_starts_app/view/widgets/common/star.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [Text('GitHubStarTrack'), kSizedBoxWidth15, Star()],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
