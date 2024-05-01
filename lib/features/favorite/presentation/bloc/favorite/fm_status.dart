import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

@immutable
abstract class FmStatus extends Equatable {}

class FmInitial extends FmStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FmCompelete extends FmStatus {
  List<MusicEntity> favoriteMusics;
  FmCompelete(this.favoriteMusics);
  @override
  List<Object?> get props => [favoriteMusics];
}

class FmError extends FmStatus {
  String? message;
  FmError(this.message);

  @override
  List<Object?> get props => [message];
}
