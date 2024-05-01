import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

abstract class FavoriteMusicRepository {

  Future<DataState<List<MusicEntity>>> fetchFavoriteMusics();
  Future<DataState<bool>> addFavoriteMusic(MusicEntity music);
  Future<DataState<bool>> removeFavoriteMusic(MusicEntity music);
}
