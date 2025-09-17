class Songg {
  final String id;
  final String title;
  final String coverUrl;
  final String artistId;
  final String audioUrl;
  final Duration? duration;

  Songg({
    required this.artistId,
    required this.title,
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
    String? audioUrl,
    Duration? duration,
  }) {
    return Songg(
      id: id ?? this.id,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      artistId: artistId ?? this.artistId,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
    );
  }

  // أضف الدالة دي في نهاية class Songg
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'artist_id': artistId,
    'title': title,
    'audio_url': audioUrl,
    'cover_url': coverUrl,
    'duration': duration?.inMilliseconds,
  };
}
}
