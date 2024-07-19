import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/utils/extensions.dart';
import 'package:vania_music/features/player/domain/usecase/extract_waveform_usecase.dart';
import 'package:waveform_extractor/model/waveform.dart';
import 'package:waveform_extractor/waveform_extractor.dart';

part 'visualiser_state.dart';

class VisualiserCubit extends Cubit<VisualiserState> {
  VisualiserCubit(this.extractWaveformUseCase)
      : super(VisualiserInitial.initial());
  final ExtractWaveformUseCase extractWaveformUseCase;

  Future<void> excuteWaveExtractor(String url) async {
    emit(VisualiserInitial.initial());
    try {
      DataState dataState = await extractWaveformUseCase(url);
      if (dataState is DataSuccess) {
        emit(VisualiserComplete(downscaledWaveformList: dataState.data));
      } else {}
    } catch (e) {
      log(e.toString());
      emit(VisualiserError());
    }
  }
}
