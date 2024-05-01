import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

import '../../../domain/repository/player_repository.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerRepository playerRepository;
  PlayerBloc(this.playerRepository) : super(PlayerInitial()) {

    on<PlayerPlay>(
      (event, emit) async {
        try {
           await playerRepository.play(event.id);
          emit(PlayerPlaying());
        } catch (e) {
          emit(PlayerError(e.toString()));
        }
      },
    );


    on<PlayerAddSongsToPlaylist>((event, emit) {
      if (playerRepository.areMediaItemsEqual(event.songs)) return;
      try {
        playerRepository.addMusicEntityToMediaItems(event.songs);
        emit(PlayerPlaylistLoaded());
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerPause>((event, emit) async {
      try {
        await playerRepository.pause();
        emit(PlayerPaused());
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerStop>((event, emit) async {
      try {
        await playerRepository.stop();
        emit(PlayerStopped());
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerSeek>((event, emit) async {
      try {
        await playerRepository.seek(event.position);
        emit(PlayerSeeked(event.position));
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerNext>((event, emit) async {
      try {
         await playerRepository.seekNext();
        emit(PlayerPlaying());
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerPrevious>((event, emit) async {
      try {
         await playerRepository.seekPrevious();
        emit(PlayerPlaying());
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerSetVolume>((event, emit) async {
      try {
        await playerRepository.setVolume(event.volume);
        emit(PlayerVolumeSet(event.volume));
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerSetSpeed>((event, emit) async {
      try {
        await playerRepository.setSpeed(event.speed);
        emit(PlayerSpeedSet(event.speed));
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerSetLoopMode>((event, emit) async {
      try {
        await playerRepository.setLoopMode(event.loopMode);
        emit(PlayerLoopModeSet(event.loopMode));
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });

    on<PlayerSetShuffleModeEnabled>((event, emit) async {
      try {
        await playerRepository.setShuffleModeEnabled(event.shuffleModeEnabled);
        emit(PlayerShuffleModeEnabledSet(event.shuffleModeEnabled));
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    });
  }
}
