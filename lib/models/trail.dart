class Trail {
  final String id;
  final String name;
  final String description;
  final double distance;
  final String difficulty;
  final String imageUrl;
  final double latitude;
  final double longitude;

  Trail({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.difficulty,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });
}