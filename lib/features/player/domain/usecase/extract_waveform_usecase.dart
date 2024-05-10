import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/usecase/use_case.dart';
import 'package:vania_music/features/player/domain/repository/visualiser_repository.dart';

class ExtractWaveformUseCase extends UseCase<DataState<List<double>>, String> {
  final VisualiserRepository visualiserRepository;
  ExtractWaveformUseCase(this.visualiserRepository);
  @override
  Future<DataState<List<double>>> call(String param) async {
    return await visualiserRepository.excuteWaveExtractor(param);
  }
}
