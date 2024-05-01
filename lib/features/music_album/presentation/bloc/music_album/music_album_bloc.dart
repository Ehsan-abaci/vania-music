import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/usecase/use_case.dart';
import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';
import 'package:vania_music/features/music_album/domain/usecases/get_music_album_usecase.dart';
part 'music_album_event.dart';
part 'music_album_state.dart';

class MusicAlbumBloc extends Bloc<MusicAlbumEvent, MusicAlbumState> {
  final GetMusicAlbumUseCase getMusicAlbumUseCase;

  MusicAlbumBloc(
    this.getMusicAlbumUseCase,
  ) : super(MusicAlbumInitial()) {
    on<FetchMusicAlbumEvent>(
      (event, emit) async {
        emit(MusicAlbumLoadingState());
        DataState dataState = await getMusicAlbumUseCase(NoParams());
        if (dataState is DataSuccess) {
          emit(MusicAlbumCompletedState(musicAlbums: dataState.data));
        } else if (dataState is DataFailed) {
          
          emit(MusicAlbumErrorState(dataState.error));
        }
      },
    );
  }
}
