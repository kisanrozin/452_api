import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      bigIncrements('prod_id'); // Kunci primer untuk produk
      bigInt('vend_id', unsigned: true); // Kolom foreign key ke vend_id
      string('prod_name', length: 50);
      integer('prod_price');
      text('prod_desc');
      timeStamps();
      
      // Menambahkan foreign key ke tabel vendors
      foreign('vend_id', 'vendors', 'vend_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
