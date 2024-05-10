import 'package:vania_music/core/resources/data_state.dart';

abstract class VisualiserRepository {
  Future<DataState<List<double>>> excuteWaveExtractor(String source);
}
