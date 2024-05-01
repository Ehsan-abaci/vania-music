import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vania_music/core/widgets/blur_background.dart';
import 'package:vania_music/features/music/presentation/bloc/music/music_bloc.dart';
import 'package:vania_music/features/music/presentation/widgets/music_widget.dart';
import 'package:vania_music/features/music/presentation/widgets/play_shuffle_widget.dart';
import 'package:vania_music/features/music_album/presentation/bloc/music_album/music_album_bloc.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';
import 'package:vania_music/locator.dart';

import '../widgets/track_list_widget.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key, required this.api});
  final String api;

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    final api =
        (context.read<MusicAlbumBloc>().state as MusicAlbumCompletedState)
            .musicAlbums
            ?.firstWhere((e) => e.link == widget.api)
            .link;
    context.read<MusicBloc>().add(FetchMusicEvent(api: api ?? ""));
  }

  bool isCollapased = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollController = _scrollController ?? ScrollController();
    _scrollController?.addListener(() {
      var specificPixel = MediaQuery.sizeOf(context).height * .1120;
      if (_scrollController!.offset.ceil() > specificPixel.ceil() &&
          !isCollapased) {
        setState(() {
          isCollapased = true;
        });
      } else if (_scrollController!.offset.ceil() < specificPixel.ceil() &&
          isCollapased) {
        setState(() {
          isCollapased = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  final _player = di<PlayerRepository>();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: StreamBuilder<MediaItem?>(
            stream: _player.mediaItem,
            builder: (context, snapshot) {
              return Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  height: snapshot.data != null
                      ? MediaQuery.sizeOf(context).height * .93
                      : MediaQuery.sizeOf(context).height,
                  child: Scrollbar(
                    controller: _scrollController,
                    interactive: true,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        MusicScreenAppBar(
                          isCollapased: isCollapased,
                          api: widget.api,
                        ),
                        MusicScreenDetail(
                          api: widget.api,
                        ),
                        const PlayShuffleWidget(),
                        const TrackListWidget(),
                      ],
                    ),
                  ));
            }),
      ),
    );
  }
}

class MusicScreenDetail extends StatelessWidget {
  MusicScreenDetail({super.key, required this.api});
  String api;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      primary: false,
      forceMaterialTransparency: true,
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: MusicWidget(
          link: api,
        ),
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: 0,
    );
  }
}

class MusicScreenAppBar extends StatelessWidget {
  MusicScreenAppBar({super.key, required this.isCollapased, required this.api});
  bool isCollapased;
  final String api;
  @override
  Widget build(BuildContext context) {
    String title =
        (context.read<MusicAlbumBloc>().state as MusicAlbumCompletedState)
                .musicAlbums
                ?.firstWhere((e) => e.link == api)
                .name??"";
    return SliverAppBar(
      title: RepaintBoundary(
        child: isCollapased
            ? Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.black,
      pinned: true,
      leading: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ),
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: const Icon(
            Icons.search_rounded,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
