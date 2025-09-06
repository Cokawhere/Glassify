class Song{
  final String id;
  final String title;
  final String coverUrl;
  final String artistId;
  final String audioUrl ;

  Song({
    required this.artistId,
    required this.title,
    required this.audioUrl,
    required this.coverUrl,
    required this.id
  });

  factory Song.formMap(Map<String,dynamic>data,String id){
    return Song(
      id: id ,
      artistId: data["artist_id"]??"",
      title: data["title"]??'',
      audioUrl: data['audio_url']??'',
      coverUrl: data['cover_url']??'',
    );
  }
}