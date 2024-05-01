import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/usecase/use_case.dart';
import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';
import 'package:vania_music/features/music_album/domain/repository/music_album_repository.dart';

class GetMusicAlbumUseCase
    extends UseCase<DataState<List<MusicAlbumEntity>>, NoParams> {
  MusicAlbumRepository musicAlbum;
  GetMusicAlbumUseCase(this.musicAlbum);
  @override
  Future<DataState<List<MusicAlbumEntity>>> call(NoParams param) async {
    return await musicAlbum.fetchMusicAlbums();
  }
}
