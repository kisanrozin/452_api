import 'package:vania/vania.dart';

class CreateVendorsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('vendors', () {
      bigIncrements('vend_id'); // Kunci primer auto-increment
      string('vend_name', length: 50);
      text('vend_address');
      text('vend_kota');
      string('vend_state', length: 5);
      string('vend_zip', length: 7);
      string('vend_country', length: 25);
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('vendors');
  }
}
