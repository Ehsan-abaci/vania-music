import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_manager_repository.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
import 'package:vania_music/features/music/domain/usecases/get_music_usecase.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final GetMusicUseCase getMusicUseCase;
  final FileManagerRepository fileManagerRepository;
  MusicBloc(this.getMusicUseCase, this.fileManagerRepository)
      : super(MusicInitial()) {
    on<FetchMusicEvent>(
      (event, emit) async {
        emit(MusicLoadingState());
        DataState dataState = await getMusicUseCase(event.api);

        if (dataState is DataSuccess) {
          List<MusicEntity> musics =
              (dataState.data as List<MusicEntity>).map((e) {
            if (fileManagerRepository.existedInLocal(e.musicUrl)) {
              return e.copyWith(isDownloaded: true);
            }
            return e;
          }).toList();
          emit(MusicCompletedState(musics: musics));
        } else if (dataState is DataFailed) {
          emit(MusicErrorState(message: dataState.error));
        }
      },
    );
    on<ChangeIsDownloadedEvent>((event, emit) {
      log("change downloaded");
      final musics = (state as MusicCompletedState).musics.map((e) {
        if (e.id == event.id) return e.copyWith(isDownloaded: true);
        return e;
      }).toList();

      emit(MusicCompletedState(musics: musics));
    });
  }
}
