

import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';

class MusicAlbumModel extends MusicAlbumEntity {
  const MusicAlbumModel({
    String? link,
    String? name,
  }) : super(link: link, name: name);

  factory MusicAlbumModel.fromJson(dynamic json) {
    return MusicAlbumModel(
      link: json['link'] as String,
      name: json['name'] as String,
    );
  }
}
