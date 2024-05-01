import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lottie/lottie.dart';
import 'package:vania_music/core/utils/resources/assets_manager.dart';
import 'package:vania_music/core/utils/resources/color_manager.dart';
import 'package:vania_music/core/widgets/blur_background.dart';
import 'package:vania_music/features/music/presentation/bloc/music/music_bloc.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';
import 'package:vania_music/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:vania_music/locator.dart';

class Tile {
  final String title;
  final String subtitle;

  Tile(this.title, this.subtitle);
}

class TrackListWidget extends StatelessWidget {
  const TrackListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MusicsList();
  }
}

class MusicsList extends StatelessWidget {
  MusicsList({super.key});
  late List<Tile> tiles = [];
  final _player = di<PlayerRepository>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state is MusicLoadingState) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is MusicErrorState) {
          return SliverFillRemaining(
            child: Center(
              child: Text(state.message ?? "Somthing went wrong..."),
            ),
          );
        } else if (state is MusicCompletedState) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            childCount: state.musics.length,
            (context, i) {
              tiles = List.generate(
                state.musics.length,
                (i) => Tile(
                  state.musics[i].name,
                  state.musics[i].time == null
                      ? state.musics[i].singer
                      : "${state.musics[i].singer} • ${state.musics[i].time}",
                ),
              );
              final num = i + 1 > 9 ? "${i + 1}" : "0${i + 1}";
              return MusicListTile(
                player: _player,
                index: i,
                num: num,
                tiles: tiles,
              );
            },
          ));
        }
        return SliverToBoxAdapter();
      },
    );
  }
}

class MusicListTile extends StatelessWidget {
  const MusicListTile({
    super.key,
    required PlayerRepository player,
    required this.index,
    required this.num,
    required this.tiles,
  }) : _player = player;

  final PlayerRepository _player;
  final int index;
  final String num;
  final List<Tile> tiles;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder<bool>(
        stream: _player.playing,
        builder: (context, snapshot) {
          var isPlaying = snapshot.data ?? false;
          return BlocBuilder<MusicBloc, MusicState>(
            builder: (context, state) {
              if (state is MusicCompletedState) {
                return ListTile(
                  onTap: () {
                    context.read<PlayerBloc>().add(
                          PlayerAddSongsToPlaylist(
                            state.musics,
                          ),
                        );
                    if (isPlaying) {
                      context.read<PlayerBloc>().add(
                            PlayerPause(),
                          );
                    }
                    context.read<PlayerBloc>().add(
                          PlayerPlay(
                            id: state.musics[index].id,
                          ),
                        );
                  },
                  // tileColor: Colors.grey.shade50,
                  leading: StreamBuilder<MediaItem?>(
                      stream: _player.mediaItem,
                      builder: (context, snapshot) {
                        return snapshot.data?.id == state.musics[index].id &&
                                isPlaying
                            ? SizedBox(
                                width: 24,
                                child: ColorFiltered(
                                  colorFilter:  ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                  child: LottieBuilder.asset(
                                    AssetsJson.equalizer,
                                  ),
                                ),
                              )
                            : Text(
                                num,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              );
                      }),
                  title: Text(
                    tiles[index].title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: StreamBuilder<MediaItem?>(
                      stream: _player.mediaItem,
                      builder: (context, snapshot) {
                        return snapshot.data?.id == state.musics[index].id
                            ? Text(
                                isPlaying ? "Now playing" : "Paused",
                                style: const TextStyle(
                                  // color: ColorManager.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Text(
                                tiles[index].subtitle,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              );
                      }),
                  trailing: IconButton(
                    onPressed: () => _player.saveMusicInStorage(
                      url: state.musics[index].musicUrl,
                    ),
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
