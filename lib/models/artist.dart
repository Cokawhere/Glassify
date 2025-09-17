class Artist {
  final String id;
  final String name;
  final String imageUrl;

  Artist({required this.id, required this.name, required this.imageUrl});

  Map<String, dynamic> toJson() => {
        'name': name,
        'image_url': imageUrl,
      };

  factory Artist.fromJson(String id, Map<String, dynamic> json) {
    return Artist(
      id: id,
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}