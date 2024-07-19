import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';

class MusicAlbumModel extends MusicAlbumEntity {
  const MusicAlbumModel({
    String? link,
    String? img,
    String? name,
  }) : super(link: link, img: img, name: name);

  factory MusicAlbumModel.fromJson(dynamic json) {
    return MusicAlbumModel(
      link: json['link'] as String,
      img: json['img'] != null ? json['img'] as String : null,
      name: json['name'] as String,
    );
  }
}
