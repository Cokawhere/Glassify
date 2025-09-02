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

class Song {
  final String id;
  final String title;
  final String coverUrl;
  final String audioUrl;
  final String artistId;

  Song({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.audioUrl,
    required this.artistId,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'cover_url': coverUrl,
    'audio_url': audioUrl,
    'artist_id': artistId,
  };

  factory Song.fromJson(String id, Map<String, dynamic> json) {
    return Song(
      id: id,
      title: json['title'],
      coverUrl: json['cover_url'],
      audioUrl: json['audio_url'],
      artistId: json['artist_id'],
    );
  }
}
