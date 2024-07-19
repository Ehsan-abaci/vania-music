import 'package:equatable/equatable.dart';

class MusicAlbumEntity extends Equatable {
  final String? link;
  final String? img;
  final String? name;
  const MusicAlbumEntity({
    this.link,
    this.img,
    this.name,
  });

  @override
  List<Object?> get props => [link, name, img];
}
