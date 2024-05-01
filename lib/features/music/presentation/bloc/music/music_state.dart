// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'music_bloc.dart';

sealed class MusicState extends Equatable{}

class MusicInitial extends MusicState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MusicLoadingState extends MusicState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class MusicCompletedState extends MusicState {
  final List<MusicEntity> musics;

  MusicCompletedState({required this.musics});

  MusicCompletedState copyWith({
    List<MusicEntity>? musics,
  }) {
    return MusicCompletedState(
      musics: musics ?? this.musics,
    );
  }
  
  @override
  List<Object?> get props => [musics];
}

class MusicErrorState extends MusicState {
  final String? message;
  MusicErrorState({required this.message});
  
  @override
  List<Object?> get props => [message];
}

