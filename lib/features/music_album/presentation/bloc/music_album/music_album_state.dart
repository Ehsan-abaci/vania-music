part of 'music_album_bloc.dart';

sealed class MusicAlbumState extends Equatable {}

class MusicAlbumInitial extends MusicAlbumState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class MusicAlbumLoadingState extends MusicAlbumState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class MusicAlbumCompletedState extends MusicAlbumState {
  final List<MusicAlbumEntity>? musicAlbums;
  MusicAlbumCompletedState({
    this.musicAlbums,
  });

  @override
  List<Object?> get props => [musicAlbums];
}

class MusicAlbumErrorState extends MusicAlbumState {
  final String? message;

  MusicAlbumErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
