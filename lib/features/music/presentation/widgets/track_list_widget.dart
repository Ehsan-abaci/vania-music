import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lottie/lottie.dart';
import 'package:vania_music/core/utils/resources/assets_manager.dart';
import 'package:vania_music/core/utils/resources/color_manager.dart';
import 'package:vania_music/core/widgets/blur_background.dart';
import 'package:vania_music/features/file_manager/presentation/value_notifier/download_file.dart';
import 'package:vania_music/features/file_manager/presentation/widget/download_dialog.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
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
              child: Text(
                state.message ?? "Somthing went wrong...",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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

class MusicListTile extends StatefulWidget {
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
  State<MusicListTile> createState() => _MusicListTileState();
}

class _MusicListTileState extends State<MusicListTile> {
  void downloadMusic(MusicEntity musicEntity) async {
    di<DownloadFile>().saveMusicInStorage(
      id: musicEntity.id,
      url: musicEntity.musicUrl,
    );
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const DownloadDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder<bool>(
        stream: widget._player.playing,
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
                            id: state.musics[widget.index].id,
                          ),
                        );
                  },
                  leading: StreamBuilder<MediaItem?>(
                      stream: widget._player.mediaItem,
                      builder: (context, snapshot) {
                        return snapshot.data?.id ==
                                    state.musics[widget.index].id &&
                                isPlaying
                            ? SizedBox(
                                width: 24,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                  child: LottieBuilder.asset(
                                    AssetsJson.equalizer,
                                  ),
                                ),
                              )
                            : Text(
                                widget.num,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              );
                      }),
                  title: Text(
                    widget.tiles[widget.index].title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: StreamBuilder<MediaItem?>(
                      stream: widget._player.mediaItem,
                      builder: (context, snapshot) {
                        return snapshot.data?.id ==
                                state.musics[widget.index].id
                            ? Text(
                                isPlaying ? "Now playing" : "Paused",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Text(
                                widget.tiles[widget.index].subtitle,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              );
                      }),
                  trailing: IconButton(
                    onPressed: () => downloadMusic(
                      state.musics[widget.index],
                    ),
                    icon: Icon(
                      !state.musics[widget.index].isDownloaded
                          ? Icons.download
                          : Icons.download_done_rounded,
                    ),
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
