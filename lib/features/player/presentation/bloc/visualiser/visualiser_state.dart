part of 'visualiser_cubit.dart';

abstract class VisualiserState extends Equatable {}

class VisualiserInitial extends VisualiserState {
   List<double> downscaledWaveformList;
  VisualiserInitial({
    required this.downscaledWaveformList,
  });

  factory VisualiserInitial.initial() {
    int _downscaledTargetSize = 100;
    return VisualiserInitial(
      downscaledWaveformList: List<double>.filled(_downscaledTargetSize, 0.1),
    );
  }
  @override
  List<Object?> get props => [downscaledWaveformList];
}

class VisualiserComplete extends VisualiserState {
   List<double> downscaledWaveformList;
  VisualiserComplete({
    required this.downscaledWaveformList,
  });
  @override
  List<Object?> get props => [downscaledWaveformList];
}

class VisualiserLoading extends VisualiserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class VisualiserError extends VisualiserState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
