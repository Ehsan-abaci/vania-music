import 'dart:async';
import 'dart:math' show Random;

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';

class PlayerRepositoryImpl extends PlayerRepository {
  PlayerRepositoryImpl() {
    loadEmptyPlaylist();
  }
  @override
  bool areMediaItemsEqual(List<MusicEntity> songs) {
    if (mediaItems.isEmpty) return false;
    return songs.first.id == mediaItems.first.id;
  }

  @override
  void addMusicEntityToMediaItems(List<MusicEntity> songs) {
    final mediaItems = getMediaItemsFromSongs(songs);
    this.mediaItems = mediaItems;
    playlist.clear();
  }

  @override
  Future<void> setCurrentIndex() async {
    currentIndexStreamController.add(currentIndex);
    lastIndex = currentIndex;
    await addMediaToPlaylist();
    currentMediaItemStreamController.add(mediaItems[lastIndex]);
  }

  @override
  Future<void> addMediaToPlaylist() async {
    await audioPlayer.dynamicSet(url: mediaItems[currentIndex].extras?['url']);
    if (playlist.contains(mediaItems[currentIndex])) return;
    playlist.add(mediaItems[currentIndex]);
  }

  // play
  @override
  Future<void> play(String? id) async {
    currentIndex = getMediaItemIndex(id ?? mediaItems[lastIndex].id);
    currentIndexStreamController.add(currentIndex);
    if (lastIndex != currentIndex) {
      lastIndex = currentIndex;
      await addMediaToPlaylist();
    }
    currentMediaItemStreamController.add(mediaItems[lastIndex]);
    await audioPlayer.play();
  }

  // play from queue
  Future<void> playFromQueue(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
    await audioPlayer.play();
  }

  // pause
  @override
  Future<void> pause() async {
    await audioPlayer.pause();
  }

  // stop
  @override
  Future<void> stop() async {
    await audioPlayer.stop();
  }

  // seek next
  @override
  Future<void> seekNext() async {
    if (audioPlayer.shuffleModeEnabled) {
      Random rd = Random();
      currentIndex = rd.nextInt(mediaItems.length - 1);
    } else {
      if (currentIndex == mediaItems.length - 1) {
        currentIndex = 0;
      } else {
        currentIndex += 1;
      }
    }
    currentIndexStreamController.add(currentIndex);
    lastIndex = currentIndex;
    await addMediaToPlaylist();
    currentMediaItemStreamController.add(mediaItems[lastIndex]);

    await audioPlayer.play();
  }

  // seek previous
  @override
  Future<void> seekPrevious() async {
    // if first song, seek to last song
    if ((await position.first).inSeconds > 5) {
      await audioPlayer.seek(Duration.zero);
    } else {
      if (audioPlayer.shuffleModeEnabled) {
        currentIndex =
            mediaItems.indexWhere((e) => e.id == playlist[lastIndex].id);
      } else {
        if (currentIndex == 0) {
          currentIndex = mediaItems.length - 1;
        } else {
          currentIndex--;
        }
      }
      currentIndexStreamController.add(currentIndex);
      lastIndex = currentIndex;
      await addMediaToPlaylist();
      currentMediaItemStreamController.add(mediaItems[lastIndex]);
      await audioPlayer.play();
    }
  }

  // seek
  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  // set volume
  @override
  Future<void> setVolume(double volume) async {
    await audioPlayer.setVolume(volume);
  }

  // set speed
  @override
  Future<void> setSpeed(double speed) async {
    await audioPlayer.setSpeed(speed);
  }

  // set loop mode
  @override
  Future<void> setLoopMode(LoopMode loopMode) async {
    await audioPlayer.setLoopMode(loopMode);
  }

  // set shuffle mode
  @override
  Future<void> setShuffleModeEnabled(bool enabled) async {
    await audioPlayer.setShuffleModeEnabled(enabled);
  }

  // dispose
  @override
  Future<void> dispose() async {
    await audioPlayer.dispose();
  }
}
