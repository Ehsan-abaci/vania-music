import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vania_music/core/utils/resources/routes.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:vania_music/features/music_album/presentation/bloc/music_album/music_album_bloc.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';
import 'package:vania_music/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:vania_music/locator.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<MusicAlbumBloc>().add(FetchMusicAlbumEvent());
    context.read<FavoriteBloc>().add(FetchFavoriteMusics());
    _stream = playerRepository.audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed && event.playing) {
        log('next music in album screen');
        context.read<PlayerBloc>().add(PlayerNext());
      }
    });
  }

  late final StreamSubscription _stream;
  final playerRepository = di<PlayerRepository>();
  @override
  void dispose() async {
    log('dispose');
    super.dispose();
    await playerRepository.dispose();
    await _stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title:  Text(
              "Vania Music 🎧",
              style: GoogleFonts.pacifico()
            ),
          ),
          BlocBuilder<MusicAlbumBloc, MusicAlbumState>(
            builder: (context, state) {
              if (state is MusicAlbumCompletedState) {
                return Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  height: MediaQuery.sizeOf(context).height * .4,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .9,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, i) {
                      return Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.pushNamed(
                                Routes.music,
                                extra: state.musicAlbums?[i].link ?? "",
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                child: Text(
                                  state.musicAlbums?[i].name!
                                          .split(" ")[0]
                                          .toUpperCase() ??
                                      "",
                                  style:  GoogleFonts.afacad(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${state.musicAlbums?[i].name}",
                            style:  GoogleFonts.aBeeZee(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          )
                        ],
                      );
                    },
                    itemCount: state.musicAlbums?.length ?? 0,
                  ),
                );
              } else if (state is MusicAlbumErrorState) {
                return Positioned.fill(
                  child: Center(
                    child: Text(state.message ?? "Somthing went wrong..."),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          Positioned.fill(
            child: Visibility(
              visible: context.watch<MusicAlbumBloc>().state
                  is MusicAlbumLoadingState,
              child: ColoredBox(
                color: Colors.grey.shade500.withOpacity(.5),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
