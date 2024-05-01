import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
import 'package:vania_music/features/music/domain/usecases/get_music_usecase.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final GetMusicUseCase getMusicUseCase;
  MusicBloc(this.getMusicUseCase) : super(MusicInitial()) {
    on<FetchMusicEvent>(
      (event, emit) async {
        emit(MusicLoadingState());
        DataState dataState = await getMusicUseCase(event.api);

        if (dataState is DataSuccess) {
          emit(MusicCompletedState(musics: dataState.data));
        } else if (dataState is DataFailed) {
          emit(MusicErrorState(message: dataState.error));
        }
      },
    );
  }
}
