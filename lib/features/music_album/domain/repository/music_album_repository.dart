
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';

abstract class MusicAlbumRepository{
  Future<DataState<List<MusicAlbumEntity>>> fetchMusicAlbums();
}