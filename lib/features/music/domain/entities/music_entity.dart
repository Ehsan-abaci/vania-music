
import 'package:equatable/equatable.dart';

class MusicEntity extends Equatable {
  final String id;
  final String singer;
  final String name;
  final String musicUrl;
  final String? imgUrl;
  final String? time;

  const MusicEntity({
    required this.id,
    required this.singer,
    required this.name,
    required this.musicUrl,
    this.imgUrl,
    this.time,
  });



  @override
  List<Object?> get props => [id, singer, name, musicUrl, imgUrl, time];
}
