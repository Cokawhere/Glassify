class Songg {
  final String id;
  final String title;
  final String coverUrl;
  final String artistId;
  final String? artistName;
  final String audioUrl;
  final Duration? duration;

  Songg({
    required this.artistId,
    required this.title,
    this.artistName,
    required this.audioUrl,
    required this.coverUrl,
    required this.id,
    this.duration,
  });

  factory Songg.formMap(Map<String, dynamic> data, String id) {
    return Songg(
      id: id,
      artistId: data["artist_id"] ?? "",
      title: data["title"] ?? '',
      artistName: data["artistName"], // Will be added by our service
      audioUrl: data['audio_url'] ?? '',
      coverUrl: data['cover_url'] ?? '',
      duration: data['duration'] != null
          ? Duration(milliseconds: data['duration'])
          : null,
    );
  }

  Songg copyWith({
    String? id,
    String? title,
    String? coverUrl,
    String? artistId,
    String? artistName,
    String? audioUrl,
    Duration? duration,
  }) {
    return Songg(
      id: id ?? this.id,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
    );
  }

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'artist_id': artistId,
    'artistName': artistName,
    'title': title,
    'audio_url': audioUrl,
    'cover_url': coverUrl,
    'duration': duration?.inMilliseconds,
  };
}
}
