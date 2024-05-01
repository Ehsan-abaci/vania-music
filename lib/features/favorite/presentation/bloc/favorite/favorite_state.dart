part of 'favorite_bloc.dart';

class FavoriteState extends Equatable {
  FmStatus fmStatus;
  TfStatus tfStatus;

  FavoriteState({
    required this.fmStatus,
    required this.tfStatus,
  });
  @override
  List<Object?> get props => [
        fmStatus,
        tfStatus,
      ];

  FavoriteState copyWith({
    FmStatus? newFmStatus,
    TfStatus? newTfStatus,
  }) {
    return FavoriteState(
      fmStatus: newFmStatus ?? fmStatus,
      tfStatus: newTfStatus ?? tfStatus,
    );
  }
}

// class FavoriteInitial extends FavoriteState {
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
// }

// class FavoriteSuccessState extends FavoriteState {
//   final List<MusicEntity> favoriteMusics;
//   FavoriteSuccessState(this.favoriteMusics);

//   @override
//   List<Object?> get props => [favoriteMusics];

//   FavoriteSuccessState copyWith({
//     List<MusicEntity>? favoriteMusics,
//   }) {
//     return FavoriteSuccessState(
//       favoriteMusics ?? this.favoriteMusics,
//     );
//   }
// }

// class FavoriteErrorState extends FavoriteState {
//   final String? message;

//   FavoriteErrorState(this.message);
//   @override
//   List<Object?> get props => [message];
// }

