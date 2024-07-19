// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'player_bloc.dart';

@immutable
sealed class PlayerEvent {}

class PlayerPlay extends PlayerEvent {
  final String id;
  PlayerPlay({
    required this.id,
  });
}

class PlayerPlayFromQueue extends PlayerEvent {
  final int index;

  PlayerPlayFromQueue(this.index);
}

class PlayerAddSongsToPlaylist extends PlayerEvent {
  final List<MusicEntity> songs;

  PlayerAddSongsToPlaylist(this.songs);
}

class PlayerPause extends PlayerEvent {}

class PlayerStop extends PlayerEvent {}

class PlayerSeek extends PlayerEvent {
  final Duration position;

  PlayerSeek(this.position);
}

class PlayerNext extends PlayerEvent {}

class PlayerPrevious extends PlayerEvent {}

class PlayerShuffle extends PlayerEvent {}

class PlayerSetVolume extends PlayerEvent {
  final double volume;

  PlayerSetVolume(this.volume);
}

class PlayerSetSpeed extends PlayerEvent {
  final double speed;

  PlayerSetSpeed(this.speed);
}

class PlayerSetLoopMode extends PlayerEvent {
  final LoopMode loopMode;

  PlayerSetLoopMode(this.loopMode);
}

class PlayerSetShuffleModeEnabled extends PlayerEvent {
  final bool shuffleModeEnabled;

  PlayerSetShuffleModeEnabled(this.shuffleModeEnabled);
}
