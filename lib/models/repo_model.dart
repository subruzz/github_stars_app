class RepoModel {
  final int id;
  final String name;
  final String ownerName;
  final String ownerAvatarUrl;
  final int stars;
  final String description;

  const RepoModel({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.stars,
    required this.description,
  });

  // Convert a JSON map into a RepoModel (for API responses)
  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? 'No description available',
      stars: json['stargazers_count'],
      ownerName: json['owner']['login'],
      ownerAvatarUrl: json['owner']['avatar_url'],
    );
  }

  // Convert a Map from SQLite into a RepoModel
  factory RepoModel.fromMap(Map<String, dynamic> map) {
    return RepoModel(
      id: map['id'] as int,
      name: map['name'],
      ownerName: map['ownerName'],
      ownerAvatarUrl: map['ownerAvatarUrl'],
      stars: map['stars'] as int,
      description: map['description'],
    );
  }

  // Convert a RepoModel into a Map (for SQLite insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ownerName': ownerName,
      'ownerAvatarUrl': ownerAvatarUrl,
      'stars': stars,
      'description': description,
    };
  }
}
