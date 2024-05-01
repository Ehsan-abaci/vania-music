// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/usecase/use_case.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
import 'package:vania_music/features/music/domain/repository/music_repository.dart';

class GetMusicUseCase extends UseCase<DataState<List<MusicEntity>>, String> {
  MusicRepository music;
  GetMusicUseCase(
    this.music,
  );
  @override
  Future<DataState<List<MusicEntity>>> call(String param) async {
    return await music.fetchMusics(param);
  }
}
