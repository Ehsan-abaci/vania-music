// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'music_bloc.dart';

sealed class MusicEvent {}

class FetchMusicEvent extends MusicEvent {
  String api;
  FetchMusicEvent({
    required this.api,
  });
}



