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

extension ListSize<N extends num> on List<N> {
  List<double> reduceListSize({
    required int targetSize,
  }) {
    if (length > targetSize) {
      final finalList = <double>[];
      final chunk = length / targetSize;
      for (int i = 0; i < targetSize; i++) {
        final part = skip((chunk * i).floor()).take(chunk.floor());
        final sum = part.fold<double>(
            0, (previousValue, element) => previousValue + element);
        final res = sum / part.length;
        finalList.add(res);
      }
      return finalList;
    } else {
      return map((e) => e.toDouble()).toList();
    }
  }
}
