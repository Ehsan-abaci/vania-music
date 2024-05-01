import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/usecase/use_case.dart';
import 'package:vania_music/features/favorite/domain/repository/favorite_music_repository.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

class GetFavoriteMusicUseCase
    extends UseCase<DataState<List<MusicEntity>>, NoParams> {
  FavoriteMusicRepository favoriteMusic;
  GetFavoriteMusicUseCase(this.favoriteMusic);
  @override
  Future<DataState<List<MusicEntity>>> call(NoParams param) async {
    return await favoriteMusic.fetchFavoriteMusics();
  }
}
