import 'package:kedai_kopi/app/http/controllers/customer_controller.dart';
import 'package:kedai_kopi/app/http/controllers/order_controller.dart';
import 'package:kedai_kopi/app/http/controllers/orderitem_controller.dart';
import 'package:kedai_kopi/app/http/controllers/product_controller.dart';
import 'package:kedai_kopi/app/http/controllers/productnote_controller.dart';
import 'package:kedai_kopi/app/http/controllers/vendor_controller.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix('api');

    // Customer Routes
    Router.post('/customer', CustomerController().create);
    Router.get('/customer', CustomerController().index);
    Router.get('/customer/{id}', CustomerController().show);
    Router.put('/customer/{id}', CustomerController().update);
    Router.delete('/customer/{id}', CustomerController().destroy);

    // Order Routes
    Router.post('/orders', OrderController().create);
    Router.get('/orders', OrderController().index);
    Router.get('/orders/{id}', OrderController().show);
    Router.put('/orders/{id}', OrderController().update);
    Router.delete('/orders/{id}', OrderController().destroy);

    // OrderItem Routes
    Router.post('/orderitems', OrderItemController().create);
    Router.get('/orderitems', OrderItemController().index);
    Router.get('/orderitems/{id}', OrderItemController().show);
    Router.put('/orderitems/{id}', OrderItemController().update);
    Router.delete('/orderitems/{id}', OrderItemController().destroy);

    // ProductNote Routes
    Router.post('/productnotes', ProductNoteController().create);
    Router.get('/productnotes', ProductNoteController().index);
    Router.get('/productnotes/{id}', ProductNoteController().show);
    Router.put('/productnotes/{id}', ProductNoteController().update);
    Router.delete('/productnotes/{id}', ProductNoteController().destroy);

    // Products Routes
    Router.post('/products', ProductController().create);
    Router.get('/products', ProductController().index);
    Router.get('/products/{id}', ProductController().show);
    Router.put('/products/{id}', ProductController().update);
    Router.delete('/products/{id}', ProductController().destroy);

    // Vendors Routes
    Router.post('/vendors', VendorController().create);
    Router.get('/vendors', VendorController().index);
    Router.get('/vendors/{id}', VendorController().show);
    Router.put('/vendors/{id}', VendorController().update);
    Router.delete('/vendors/{id}', VendorController().destroy);
  }
}