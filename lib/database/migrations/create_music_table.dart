import 'package:vania/vania.dart';

class CreateMusicTable extends Migration {

  @override
  Future<void> up() async{
    super.up();
   await createTable('music', () {
      id();
      text('singer',nullable: true);
      text('name',nullable: true);
      text('link_128',nullable: true);
      text('link_320',nullable: true);
    });
  }
}
