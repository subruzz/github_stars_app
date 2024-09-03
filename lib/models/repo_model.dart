class RepoModel {
  final String name;
  final String description;
  final int stars;
  final String ownerName;
  final String ownerAvatarUrl;
  final String updatedat;
  RepoModel({
    required this.updatedat,
    required this.name,
    required this.description,
    required this.stars,
    required this.ownerName,
    required this.ownerAvatarUrl,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      updatedat: json['updated_at'],
      name: json['name'],
      description: json['description'] ?? 'No description available',
      stars: json['stargazers_count'],
      ownerName: json['owner']['login'],
      ownerAvatarUrl: json['owner']['avatar_url'],
    );
  }
}
