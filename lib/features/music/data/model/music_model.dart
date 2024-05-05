import 'dart:convert';
import 'dart:developer';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

class MusicModel extends MusicEntity {
   MusicModel({
    String? id,
    String? singer,
    String? name,
    String? musicUrl,
    String? imgUrl,
    String? time,
    // required super.id,
    // required super.singer,
    // required super.name,
    // required super.musicUrl,
    // super.imgUrl,
    // super.time,
  }) : super(
          id: id ?? "",
          name: name ?? "",
          singer: singer ?? "",
          musicUrl: musicUrl ?? "",
          imgUrl: imgUrl,
          time: time,
        );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'singer': singer,
      'name': name,
      'music': musicUrl,
      'img': imgUrl,
      'time': time,
    };
  }

  factory MusicModel.fromJson(dynamic json) {
    return MusicModel(
      id: (json['name'] as String) + (json['singer'] as String),
      singer: json['singer'] as String,
      name: json['name'] as String,
      musicUrl: json['music'] as String,
      imgUrl: json['img'] != null ? json['img'] as String : null,
      time: json['time'] != null ? json['time'] as String : null,
    );
  }
}
