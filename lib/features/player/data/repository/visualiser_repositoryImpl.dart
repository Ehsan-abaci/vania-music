import 'dart:async';
import 'dart:developer';

import 'package:rxdart/subjects.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/utils/extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_manager_repository.dart';
import 'package:vania_music/features/player/domain/repository/visualiser_repository.dart';
import 'package:waveform_extractor/model/waveform.dart';
import 'package:waveform_extractor/waveform_extractor.dart';

class VisualiserRepositoryImpl extends VisualiserRepository {
  final FileManagerRepository fileManagerRepository;
  VisualiserRepositoryImpl(this.fileManagerRepository);

  Waveform? _currentWaveform;
  static const int _downscaledTargetSize = 100;
  final _waveformExtractor = WaveformExtractor();

  @override
  Future<DataState<List<double>>> excuteWaveExtractor(String source) async {
    await fileManagerRepository
        .existedInLocalStream(source)
        .then((filePath) async {
      if (filePath != null) {
        log(filePath);
        _currentWaveform = await _waveformExtractor.extractWaveform(filePath);
      }
    });
    log(" length in repositoryyyyyyyy ${_currentWaveform?.waveformData.length}");

    final updatedDownScaledList = _updateDownscaledList(
        _currentWaveform?.waveformData, _downscaledTargetSize);
    log(" length in repository ${updatedDownScaledList.length}");
    return DataSuccess(updatedDownScaledList);
  }

  List<double> _updateDownscaledList(List<int>? list, int targetSize) {
    final downscaled = list?.reduceListSize(targetSize: targetSize);
    final newDownscaledWaveformList = downscaled ?? [];
    return newDownscaledWaveformList;
  }
}
