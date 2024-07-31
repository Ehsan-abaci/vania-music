import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appbar_expanded_state.dart';

class AppbarExpandedCubit extends Cubit<AppbarExpandedState> {
  AppbarExpandedCubit() : super(AppbarExpandedInitial(isCollapased: false));

  toggleExpandation(bool isCollapased) {
    emit(AppbarExpandedInitial(isCollapased: isCollapased));
  }
}
