import 'package:just_audio_background/just_audio_background.dart';
import 'package:vania_music/features/music/data/model/music_model.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

extension ToHMS on Duration {
  String toHms() {
    var hour = inHours;
    var minute = inMinutes - hour * 60;
    var second = inSeconds - minute * 60;

    return "${hour == 0 ? '' : "$hour:"}$minute:${second < 10 ? "0$second" : second}";
  }
}

extension MediaItemToMusic on MediaItem? {
  MusicModel toMusic() {
    return MusicModel(
      id: this?.id ?? "0",
      singer: this?.artist ?? "",
      name: this?.title ?? "",
      musicUrl: this?.extras?['url'],
      imgUrl: this?.extras?['img'],
    );
  }
}
