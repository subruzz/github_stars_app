import 'package:flutter/material.dart';
import 'package:github_starts_app/utils/constants/ui_constants.dart';
import 'package:github_starts_app/utils/extensions/start_count_formatted_string.dart';
import 'package:github_starts_app/view/widgets/home_screen/repo_card_avatar.dart';
import '../../../models/repo_model.dart';
import '../common/expandable_text.dart';

class GithubRepoCard extends StatelessWidget {
  final RepoModel repo;

  const GithubRepoCard({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepoCard(avatarUrl: repo.ownerAvatarUrl),
            kSizedBoxWidth15,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${repo.name}/${repo.ownerName}',
                          style: kHeadingTextStyle.copyWith(
                              color: kRepoDetailsColor, fontSize: 15.5),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Row(
                        children: [
                          Text(repo.stars.formattedStars,
                              style: kBodyTextStyle.copyWith(
                                  color: kBlack, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 5.0),
                          const Icon(
                            Icons.star,
                            color: kStarColor,
                            size: 18.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  kSizedBoxHeight5,
                  ExpandableText(
                    text: repo.description,
                    trimLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
