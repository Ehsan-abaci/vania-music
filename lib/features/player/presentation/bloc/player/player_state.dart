// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'player_bloc.dart';

sealed class PlayerState extends Equatable {}

class PlayerInitial extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerPlaying extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerPaused extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerStopped extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerSeeked extends PlayerState {
  final Duration position;

  PlayerSeeked(this.position);

  @override
  List<Object?> get props => [position];
}

class PlayerPlaylistLoaded extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerError extends PlayerState {
  final String? message;

  PlayerError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlayerLoading extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerNexted extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerPrevioussed extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerShuffled extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerLooped extends PlayerState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PlayerVolumeSet extends PlayerState {
  final double volume;

  PlayerVolumeSet(this.volume);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class PlayerSpeedSet extends PlayerState {
  final double speed;

  PlayerSpeedSet(this.speed);

  @override
  List<Object?> get props => [speed];
}

class PlayerLoopModeSet extends PlayerState {
  final LoopMode loopMode;

  PlayerLoopModeSet(this.loopMode);

  @override
  List<Object?> get props => [loopMode];
}

class PlayerShuffleModeEnabledSet extends PlayerState {
  final bool shuffleModeEnabled;

  PlayerShuffleModeEnabledSet(this.shuffleModeEnabled);

  @override
  List<Object?> get props => [shuffleModeEnabled];
}
