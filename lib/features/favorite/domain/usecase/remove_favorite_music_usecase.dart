import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/usecase/use_case.dart';
import 'package:vania_music/features/favorite/domain/repository/favorite_music_repository.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

class RemoveFavoriteMusicUseCase extends UseCase<DataState<bool>, MusicEntity> {
  FavoriteMusicRepository favoriteMusic;
  RemoveFavoriteMusicUseCase(this.favoriteMusic);
  @override
  Future<DataState<bool>> call(MusicEntity param) async {
    return await favoriteMusic.removeFavoriteMusic(param);
  }
}
