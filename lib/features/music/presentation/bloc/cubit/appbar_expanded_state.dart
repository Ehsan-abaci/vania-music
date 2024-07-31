part of 'appbar_expanded_cubit.dart';

abstract class AppbarExpandedState extends Equatable {
  
}

class AppbarExpandedInitial extends AppbarExpandedState {
  bool isCollapased;
  AppbarExpandedInitial({
    required this.isCollapased,
  });

  @override
  List<Object?> get props => [isCollapased];
}
