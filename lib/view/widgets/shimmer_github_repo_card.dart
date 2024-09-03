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
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRadius10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
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
                                height: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Row(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 16.0,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5.0),
                                const Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                  size: 18.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        kSizedBoxHeight5,
                        Container(
                          height: 60.0,
                          color: Colors.grey,
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
