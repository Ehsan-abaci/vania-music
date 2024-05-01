// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class TfStatus extends Equatable {}

class TfLoading extends TfStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TfComplete extends TfStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TfError extends TfStatus {
  String? message;
  TfError(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
