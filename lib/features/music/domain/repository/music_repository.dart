import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

abstract class MusicRepository {
  Future<DataState<List<MusicEntity>>> fetchMusics(String api);
  
}
