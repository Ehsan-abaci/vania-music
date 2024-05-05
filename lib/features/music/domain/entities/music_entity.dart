// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class MusicEntity extends Equatable {
  final String id;
  final String singer;
  final String name;
  final String musicUrl;
  final String? imgUrl;
  final String? time;
  bool isDownloaded;

  MusicEntity({
    required this.id,
    required this.singer,
    required this.name,
    required this.musicUrl,
    this.imgUrl,
    this.time,
    this.isDownloaded = false,
  });

  @override
  List<Object?> get props => [id, singer, name, musicUrl, imgUrl, time];

  MusicEntity copyWith({
    String? id,
    String? singer,
    String? name,
    String? musicUrl,
    String? imgUrl,
    String? time,
    bool? isDownloaded,
  }) {
    return MusicEntity(
      id: id ?? this.id,
      singer: singer ?? this.singer,
      name: name ?? this.name,
      musicUrl: musicUrl ?? this.musicUrl,
      imgUrl: imgUrl ?? this.imgUrl,
      time: time ?? this.time,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
