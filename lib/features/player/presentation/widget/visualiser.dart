import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vania_music/core/utils/extensions.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';
import 'package:vania_music/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:vania_music/features/player/presentation/bloc/visualiser/visualiser_cubit.dart';
import 'package:vania_music/locator.dart';
import 'package:waveform_extractor/model/waveform.dart';
import 'package:waveform_extractor/waveform_extractor.dart';

class Visualiser extends StatefulWidget {
  Visualiser({super.key, required this.url, required this.width});
  String url;
  double width;
  @override
  State<Visualiser> createState() => _VisualiserState();
}

class _VisualiserState extends State<Visualiser>
    with AutomaticKeepAliveClientMixin {
  double _barWidth = 2;
  Waveform? _currentWaveform;
  List<double> _downscaledWaveformList = [];
  int _downscaledTargetSize = 100;

  final horizontalPadding = 24.0;

  final _player = di<PlayerRepository>();

  void excuteWaveExtractor() {
    context.read<VisualiserCubit>().excuteWaveExtractor(widget.url);
  }

  _onVisualiserTap(TapUpDetails details, Duration duration) {
    var val =
        ((details.localPosition.dx / MediaQuery.sizeOf(context).width * 1.2) *
                duration.inMilliseconds)
            .clamp(0, duration.inMilliseconds);
    context.read<PlayerBloc>().add(PlayerSeek(
          Duration(
            milliseconds: val.toInt(),
          ),
        ));
  }

  _onVisualiserUpdate(DragUpdateDetails details, Duration duration) {
    var val =
        ((details.localPosition.dx / MediaQuery.sizeOf(context).width * 1.2) *
                duration.inMilliseconds)
            .clamp(0, duration.inMilliseconds);

    context.read<PlayerBloc>().add(PlayerSeek(
          Duration(
            milliseconds: val.toInt(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<MediaItem?>(
        stream: di<PlayerRepository>().mediaItem,
        builder: (context, snapshot) {
          if (snapshot.hasData) excuteWaveExtractor();
          return StreamBuilder<Duration>(
              stream: _player.position,
              builder: (context, snapshot) {
                var position = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                    stream: _player.duration,
                    builder: (context, snapshot) {
                      var duration = snapshot.data ?? Duration.zero;
                      final value = duration == Duration.zero
                          ? 0
                          : (position.inMilliseconds /
                                  duration.inMilliseconds) *
                              100;
                      return GestureDetector(
                        onTapUp: (details) =>
                            _onVisualiserTap(details, duration),
                        onPanUpdate: (details) =>
                            _onVisualiserUpdate(details, duration),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0)),
                          width: widget.width,
                          child: BlocBuilder<VisualiserCubit, VisualiserState>(
                            builder: (context, state) {
                              if (state is VisualiserComplete) {
                                _downscaledWaveformList =
                                    state.downscaledWaveformList;
                              } else if (state is VisualiserInitial) {
                                _downscaledWaveformList =
                                    state.downscaledWaveformList;
                              }

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ...List.generate(
                                    _downscaledWaveformList.length,
                                    (i) {
                                      var e = _downscaledWaveformList[i];
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                            color: value.toInt() >= i
                                                // ? Theme.of(context).colorScheme.onSecondary
                                                ? Colors.grey.shade700
                                                : Colors.white70,
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                        height: (e).clamp(1.0, 50),
                                        width: _barWidth,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    });
              });
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
