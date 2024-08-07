import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vania_music/config/theme/bloc/theme_bloc.dart';
import 'package:vania_music/core/utils/extensions.dart';
import 'package:vania_music/core/utils/resources/assets_manager.dart';
import 'package:vania_music/core/utils/resources/color_manager.dart';
import 'package:vania_music/core/widgets/svg_button.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/fm_status.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';
import 'package:vania_music/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:vania_music/features/player/presentation/widget/visualiser.dart';
import 'package:vania_music/locator.dart';

AnimationController? bottomSheetSizeController;

class MusicBottomSheet extends StatefulWidget {
  const MusicBottomSheet({super.key});

  @override
  State<MusicBottomSheet> createState() => _MusicBottomSheetState();
}

class _MusicBottomSheetState extends State<MusicBottomSheet>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Animation? _bottomSheetSizeAnimation;
  Animation? _imageAnimation;
  Animation? _leftMarginAnimation;
  Animation? _topMarginAnimation;
  Animation? _borderRadiusAnimation;
  Animation? _opacityAnimation;

  final PlayerRepository _player = di<PlayerRepository>();

  @override
  void didChangeDependencies() {
    log("did change dep");
    bottomSheetSizeController = bottomSheetSizeController ??
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        );
    _bottomSheetSizeAnimation = _bottomSheetSizeAnimation ??
        Tween<double>(
          begin: 70,
          end: MediaQuery.sizeOf(context).height - 50,
        ).animate(
          CurvedAnimation(
            parent: bottomSheetSizeController!,
            curve: Curves.linear,
          ),
        );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: bottomSheetSizeController!,
        curve: Curves.linear,
      ),
    );

    _leftMarginAnimation = _leftMarginAnimation ??
        Tween<double>(begin: 10, end: 70).animate(
          CurvedAnimation(
              parent: bottomSheetSizeController!, curve: Curves.linear),
        );

    _topMarginAnimation = _topMarginAnimation ??
        Tween<double>(begin: 0, end: 60).animate(
          CurvedAnimation(
              parent: bottomSheetSizeController!, curve: Curves.linear),
        );
    _borderRadiusAnimation = _borderRadiusAnimation ??
        Tween<double>(begin: 10, end: 15).animate(CurvedAnimation(
            parent: bottomSheetSizeController!, curve: Curves.linear));

    super.didChangeDependencies();
  }

  _handleDragUpdate(DragUpdateDetails details) {
    if (details.globalPosition.dy < 200) return;
    bottomSheetSizeController?.value -= details.primaryDelta! / 800;
  }

  _handleDragEnd(DragEndDetails details) {
    if (bottomSheetSizeController!.isAnimating ||
        bottomSheetSizeController?.status == AnimationStatus.completed) return;

    final flingVelocity = details.velocity.pixelsPerSecond.dy / 500;
    if (flingVelocity < 0.0) {
      bottomSheetSizeController?.fling(velocity: 2);
    } else if (flingVelocity > 0.0) {
      bottomSheetSizeController?.fling(velocity: -2);
    } else {
      bottomSheetSizeController?.fling(
          velocity: bottomSheetSizeController!.value < 0.5 ? -2.0 : 2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("build widget");
    _imageAnimation =
        Tween<double>(begin: 50, end: MediaQuery.sizeOf(context).height * .3)
            .animate(
      CurvedAnimation(
          parent: bottomSheetSizeController!, curve: Curves.linearToEaseOut),
    );
    return AnimatedBuilder(
      animation: bottomSheetSizeController!,
      builder: (context, child) => GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        onTap: bottomSheetSizeController?.forward,
        child: Container(
          height: _bottomSheetSizeAnimation?.value,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          color: ColorManager.bg,
          child: StreamBuilder<MediaItem?>(
              stream: _player.mediaItem,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                return RepaintBoundary(
                  child: Stack(
                    children: [
                      if (bottomSheetSizeController?.status ==
                          AnimationStatus.completed)
                        bgImage(),
                      if (bottomSheetSizeController?.status ==
                          AnimationStatus.dismissed)
                        musicControler(),
                      if (bottomSheetSizeController?.status ==
                          AnimationStatus.completed)
                        musicBar(),
                      if (bottomSheetSizeController?.status ==
                          AnimationStatus.completed)
                        musicExtendedControler(),
                      musicImage(),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget bgImage() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image.asset(
        "assets/img_blur_bg.png",
        color: Theme.of(context).colorScheme.secondary,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget musicBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: bottomSheetSizeController?.reverse,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          color: Colors.white,
          iconSize: 30,
        ),
        centerTitle: true,
        title: const Text(
          "Now Playing",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.queue_music_rounded,
            ),
            color: Colors.white,
            iconSize: 30,
          ),
        ],
      ),
    );
  }

  Widget musicControler() {
    return Positioned(
      right: 70,
      left: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              StreamBuilder<bool>(
                  stream: _player.playing,
                  builder: (context, snapshot) {
                    var isPlaying = snapshot.data ?? false;
                    return StreamBuilder<MediaItem?>(
                        stream: _player.mediaItem,
                        builder: (context, snapshot) {
                          var currentItem = snapshot.data;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size.square(50),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              if (isPlaying) {
                                context.read<PlayerBloc>().add(
                                      PlayerPause(),
                                    );
                              } else {
                                context.read<PlayerBloc>().add(
                                      PlayerPlay(id: currentItem!.id),
                                    );
                              }
                            },
                            child: Icon(
                              isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow_rounded,
                            ),
                          );
                        });
                  }),
              const SizedBox(
                width: 10,
              ),
              StreamBuilder<MediaItem?>(
                  stream: _player.mediaItem,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final currentMusic = snapshot.data;
                    return IconButton(
                      onPressed: () => context
                          .read<FavoriteBloc>()
                          .add(ToggleFavorite(music: snapshot.data.toMusic())),
                      icon: BlocBuilder<FavoriteBloc, FavoriteState>(
                        buildWhen: (previous, current) {
                          if (previous.tfStatus == current.tfStatus) {
                            return false;
                          }
                          return true;
                        },
                        builder: (context, state) {
                          if (state.fmStatus is FmCompelete) {
                            return (state.fmStatus as FmCompelete)
                                    .favoriteMusics
                                    .any(
                                      (e) => e.id == currentMusic!.id,
                                    )
                                ? const Icon(Icons.favorite_rounded,
                                    color: Colors.white)
                                : const Icon(
                                    Icons.favorite_border_rounded,
                                    color: Colors.grey,
                                  );
                          }

                          return const SizedBox();
                        },
                      ),
                      color: Colors.grey,
                    );
                  }),
            ],
          ),
          StreamBuilder<int?>(
              stream: _player.currentIndexStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                var mediaItem =
                    _player.mediaItems[snapshot.data ?? _player.currentIndex];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      mediaItem.title,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      mediaItem.artist!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget musicImage() {
    return AnimatedBuilder(
      animation: bottomSheetSizeController!,
      builder: (context, child) {
        return Positioned(
          left: bottomSheetSizeController?.status == AnimationStatus.completed
              ? _leftMarginAnimation?.value
              : null,
          right: _leftMarginAnimation?.value,
          top: _topMarginAnimation?.value,
          child: RepaintBoundary(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                width: _imageAnimation?.value,
                height: _imageAnimation?.value,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(_borderRadiusAnimation?.value),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.secondary,
                      blurRadius: 25,
                      offset: const Offset(0, 5),
                    )
                  ],
                  color: ColorManager.bg,
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(_borderRadiusAnimation?.value),
                  child: StreamBuilder<MediaItem?>(
                      stream: _player.mediaItem,
                      builder: (context, snapshot) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data?.extras?['img'] ?? '',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const AspectRatio(
                            aspectRatio: 1.7,
                            child: FittedBox(
                              child: Text(
                                "Vania\nMusic",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget musicExtendedControler() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: SizedBox(
        height: 370,
        child: Opacity(
          opacity: _opacityAnimation?.value,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getToggleFavoriteButton(),
                    _getName(),
                    CustomIconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz_rounded),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ..._getVisualiser(),
              const SizedBox(height: 20),
              //! controller of player
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _getShuffleButton(),
                  _getPlayPreviousButton(),
                  _getPlayAndPauseButton(),
                  _getPlayNextButton(),
                  _getRepeatButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<int?> _getName() {
    return StreamBuilder<int?>(
        stream: _player.currentIndexStream,
        builder: (context, snapshot) {
          var mediaItem =
              _player.mediaItems[snapshot.data ?? _player.currentIndex];
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    mediaItem.title,
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  mediaItem.artist!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        });
  }

  StreamBuilder<MediaItem?> _getToggleFavoriteButton() {
    return StreamBuilder<MediaItem?>(
        stream: _player.mediaItem,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final currentMusic = snapshot.data;
          return RepaintBoundary(
            child: IconButton(
              onPressed: () => context.read<FavoriteBloc>().add(
                    ToggleFavorite(
                      music: snapshot.data.toMusic(),
                    ),
                  ),
              icon: BlocBuilder<FavoriteBloc, FavoriteState>(
                buildWhen: (previous, current) {
                  if (previous.tfStatus == current.tfStatus) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state.fmStatus is FmCompelete) {
                    return (state.fmStatus as FmCompelete)
                            .favoriteMusics
                            .any((e) => e.id == currentMusic!.id)
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                          );
                  }

                  return const SizedBox();
                },
              ),
              color: Colors.grey,
            ),
          );
        });
  }

  List<Widget> _getVisualiser() {
    return [
      StreamBuilder<MediaItem?>(
          stream: _player.mediaItem,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            var mediaItem = snapshot.data;
            return RepaintBoundary(
              child: Visualiser(
                url: mediaItem?.extras?['url'],
                width: MediaQuery.sizeOf(context).width * .83,
              ),
            );
          }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: RepaintBoundary(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<Duration>(
                  stream: _player.position,
                  builder: (context, snapshot) {
                    var currentPosition = snapshot.data ?? Duration.zero;
                    return Text(
                      currentPosition.toHms(),
                    );
                  }),
              StreamBuilder<Duration?>(
                  stream: _player.duration,
                  builder: (context, snapshot) {
                    var duration = snapshot.data ?? Duration.zero;
                    return Text(
                      duration.toHms(),
                      style: const TextStyle(color: Colors.grey),
                    );
                  }),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _getPlayNextButton() {
    return SVGButton(
      function: () => context.read<PlayerBloc>().add(PlayerNext()),
      color: Colors.white,
      icon: AssetsIcon.next,
    );
  }

  Widget _getRepeatButton() {
    return SVGButton(
      function: () {},
      color: Colors.grey,
      icon: AssetsIcon.repeat,
    );
  }

  StreamBuilder<bool> _getPlayAndPauseButton() {
    return StreamBuilder<bool>(
        stream: _player.playing,
        builder: (context, snapshot) {
          var isPlaying = snapshot.data ?? false;
          return StreamBuilder<MediaItem?>(
              stream: _player.mediaItem,
              builder: (context, snapshot) {
                var currentItem = snapshot.data;
                return RepaintBoundary(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      fixedSize: const Size.fromRadius(35),
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        context.read<PlayerBloc>().add(
                              PlayerPause(),
                            );
                      } else {
                        context.read<PlayerBloc>().add(
                              PlayerPlay(id: currentItem!.id),
                            );
                      }
                    },
                    child: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                );
              });
        });
  }

  Widget _getPlayPreviousButton() {
    return SVGButton(
      function: () => context.read<PlayerBloc>().add(PlayerPrevious()),
      color: Colors.white,
      icon: AssetsIcon.prev,
    );
  }

  Widget _getShuffleButton() {
    return StreamBuilder<bool>(
      stream: _player.shuffleModeEnabled,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isEnable = snapshot.data!;
          return SVGButton(
            function: () => context
                .read<PlayerBloc>()
                .add(PlayerSetShuffleModeEnabled(!isEnable)),
            icon: AssetsIcon.shuffle,
            color: isEnable == false ? Colors.grey : Colors.white,
          );
        }
        return const Align();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
    this.size,
  });
  final Widget icon;
  final VoidCallback onPressed;
  final Color color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: color,
      iconSize: size,
    );
  }
}
