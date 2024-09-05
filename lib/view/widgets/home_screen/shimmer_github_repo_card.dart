import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:github_starts_app/utils/constants/ui_constants.dart';

class ShimmerGithubRepoCard extends StatelessWidget {
  const ShimmerGithubRepoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: kShimmerBaseColor,
          highlightColor: kShimmerHighlightColor,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadius10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kSpacing16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: kGreyColor,
                    radius: kRadius30,
                  ),
                  kSizedBoxWidth15,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height:
                                    kFontSize18, // Adjust height based on font size
                                color: kGreyColor,
                              ),
                            ),
                            kSizedBoxHeight10,
                            Row(
                              children: [
                                Container(
                                  width: kFontSize18 *
                                      2.5, // Adjust width based on font size
                                  height: kFontSize18,
                                  color: kGreyColor,
                                ),
                                kSizedBoxWidth5,
                                const Icon(
                                  Icons.star,
                                  color: kStarColor, // Use star color
                                  size: kFontSize18,
                                ),
                              ],
                            ),
                          ],
                        ),
                        kSizedBoxHeight5,
                        Container(
                          height: kFontSize18 *
                              3.5, // Adjust height based on font size
                          color: kGreyColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
