import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/usecase/use_case.dart';
import 'package:vania_music/features/favorite/domain/usecase/add_favorite_music_usecase.dart';
import 'package:vania_music/features/favorite/domain/usecase/get_favorite_music_usecase.dart';
import 'package:vania_music/features/favorite/domain/usecase/remove_favorite_music_usecase.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/fm_status.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/tf_status.dart';
import 'package:vania_music/features/music/data/model/music_model.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AddFavoriteMusicUseCase addFavoriteMusicUseCase;
  final RemoveFavoriteMusicUseCase removeFavoriteMusicUseCase;
  final GetFavoriteMusicUseCase getFavoriteMusicUseCase;
  FavoriteBloc(
    this.addFavoriteMusicUseCase,
    this.getFavoriteMusicUseCase,
    this.removeFavoriteMusicUseCase,
  ) : super(FavoriteState(
          fmStatus: FmInitial(),
          tfStatus: TfLoading(),
        )) {
    on<ToggleFavorite>((event, emit) async {
      emit(state.copyWith(newTfStatus: TfLoading()));
      final id = event.music.id;
      final fMusics = (state.fmStatus as FmCompelete).favoriteMusics;
      if (fMusics.any((e) => (e.id) == id)) {
        try {
          DataState dataState = await removeFavoriteMusicUseCase(event.music);
          if (dataState is DataSuccess) {
            emit(
              state.copyWith(
                  newFmStatus: FmCompelete(
                    fMusics..remove(event.music),
                  ),
                  newTfStatus: TfComplete()),
            );
          } else if (dataState is DataFailed) {
            emit(state.copyWith(newTfStatus: TfError(dataState.error)));
          }
        } catch (e) {
          log(e.toString());
        }
      } else {
        try {
          DataState dataState =
              await addFavoriteMusicUseCase(event.music as MusicModel);
          if (dataState is DataSuccess) {
            emit(
              state.copyWith(
                newFmStatus: FmCompelete(
                  fMusics..add(event.music),
                ),
                newTfStatus: TfComplete(),
              ),
            );
          } else if (dataState is DataFailed) {
            emit(state.copyWith(newTfStatus: TfError(dataState.error)));
          }
        } catch (e) {
          log(e.toString());
        }
      }
    });

    on<FetchFavoriteMusics>((event, emit) async {
      try {
        DataState dataState = await getFavoriteMusicUseCase(NoParams());
        if (dataState is DataSuccess) {
          emit(state.copyWith(newFmStatus: FmCompelete(dataState.data)));
        } else if (dataState is DataFailed) {
          emit(state.copyWith(newFmStatus: FmError(dataState.error)));
        }
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
