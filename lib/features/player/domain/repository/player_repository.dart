import 'dart:async';
import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

abstract class PlayerRepository {
  final audioPlayer = AudioPlayer();

  int currentIndex = -1;
  int lastIndex = -1;

  // playlist
  final playlist = <MediaItem>[];
  // media items
  var mediaItems = <MediaItem>[];

  final StreamController<int?> currentIndexStreamController = BehaviorSubject()
    ..add(null);
  final StreamController<MediaItem?> currentMediaItemStreamController =
      BehaviorSubject()..add(null);

  // current index
  Stream<int?> get currentIndexStream => currentIndexStreamController.stream;

  // current media item
  Stream<String?> get mediaItemId => mediaItems.isEmpty
      ? Stream.value(null)
      : currentIndexStream.map((index) => mediaItems[index!].id);

  // current media item
  Stream<MediaItem?> get mediaItem => currentMediaItemStreamController.stream;

  // current position
  Stream<Duration> get position => audioPlayer.positionStream;

  // current position
  Stream<Duration> get bufferPosition => audioPlayer.bufferedPositionStream;

  // duration
  Stream<Duration?> get duration => audioPlayer.durationStream;

  // shuffle mode enabled
  Stream<bool> get shuffleModeEnabled => audioPlayer.shuffleModeEnabledStream;

  // loop mode
  Stream<LoopMode> get loopMode => audioPlayer.loopModeStream;

  // playing
  Stream<bool> get playing => audioPlayer.playingStream;

  bool areMediaItemsEqual(List<MusicEntity> songs);
  Future<void> addMediaToPlaylist();
  Future<void> play(String id);
  Future<void> pause();
  Future<void> stop();
  Future<void> seekNext();
  Future<void> seekPrevious();
  Future<void> seek(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setSpeed(double speed);
  Future<void> setLoopMode(LoopMode loopMode);
  Future<void> setShuffleModeEnabled(bool enabled);
  void addMusicEntityToMediaItems(List<MusicEntity> songs);
  Future<void> dispose();

  Future<void> loadEmptyPlaylist() async {
    try {
      await audioPlayer.setAudioSource(ConcatenatingAudioSource(children: []));
    } catch (err) {
      log("Error: $err");
    }
  }

  // song model to media item
  static MediaItem getMediaItemFromSong(MusicEntity song) {
    return MediaItem(
      id: song.id,
      title: song.name,
      artist: song.singer,
      extras: {
        'url': song.musicUrl,
        'img': song.imgUrl,
      },
    );
  }

  // song models to media items
  List<MediaItem> getMediaItemsFromSongs(List<MusicEntity> songs) {
    return songs.map((song) => getMediaItemFromSong(song)).toList();
  }

  Future<void> setCurrentIndex();

  int getMediaItemIndex(String id) {
    return mediaItems.indexWhere((item) => item.id == id);
  }
}
