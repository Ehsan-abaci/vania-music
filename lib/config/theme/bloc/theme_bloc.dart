import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:vania_music/config/theme/theme_config.dart';
import 'package:vania_music/core/utils/palette_genrator.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final Stream<MediaItem?> _currentMusicStreaam;
  late StreamSubscription _streamSubscription;
  ThemeBloc(
    this._currentMusicStreaam,
  ) : super(ThemeInitial(theme: ThemeConfig.initialTheme())) {
    _streamSubscription = _currentMusicStreaam.listen(
      (mediaItem) async {
        if (mediaItem == null) return;
        final palatte = await paletteGenerator(mediaItem.extras?['img']);

        final primarySwatchColor =
            generateMaterialColor(color: palatte.dominantColor!.color);

        emit(
          ThemeComplete(
            ThemeConfig.newTheme(primarySwatchColor),
          ),
        );
      },
    );
  }
  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
