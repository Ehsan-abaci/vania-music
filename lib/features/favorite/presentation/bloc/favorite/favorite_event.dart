part of 'favorite_bloc.dart';

class FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final MusicEntity music;
  ToggleFavorite({
    required this.music,
  });
}

class FetchFavoriteMusics extends FavoriteEvent {}
