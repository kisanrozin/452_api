import 'package:vania/vania.dart';
import 'package:kedai_kopi/app/models/orderitem.dart';

class OrderItemController extends Controller {
  // Mendapatkan semua data order items
  Future<Response> index() async {
    try {
      final orderItems = await OrderItem().query().get();
      return Response.json({
        'message': 'Daftar item pesanan berhasil diambil.',
        'data': orderItems,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil daftar item pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menambahkan item ke dalam pesanan
  Future<Response> create(Request req) async {
    req.validate({
      'order_num': 'required|numeric',
      'prod_id': 'required|numeric',
      'quantity': 'required|numeric',
      'size': 'required|numeric',
    }, {
      'order_num.required': 'Nomor pesanan tidak boleh kosong.',
      'prod_id.required': 'ID produk tidak boleh kosong.',
      'quantity.required': 'Kuantitas tidak boleh kosong.',
      'size.required': 'Ukuran tidak boleh kosong.',
    });

    final orderItemData = req.input();
    orderItemData['created_at'] = DateTime.now().toIso8601String();

    await OrderItem().query().insert(orderItemData);

    return Response.json({
      'message': 'Item berhasil ditambahkan ke dalam pesanan.',
      'data': orderItemData,
    }, 201);
  }

  // Menampilkan item pesanan berdasarkan ID
  Future<Response> show(Request req, int id) async {
    try {
      final orderItem = await OrderItem().query().where('order_item', '=', id).first();
      if (orderItem == null) {
        return Response.json({
          'message': 'Item pesanan tidak ditemukan.',
        }, 404);
      }

      return Response.json({
        'message': 'Item pesanan ditemukan.',
        'data': orderItem,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil item pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui item pesanan berdasarkan ID
  Future<Response> update(Request req, int id) async {
    try {
      req.validate({
        'order_num': 'numeric',
        'prod_id': 'numeric',
        'quantity': 'numeric',
        'size': 'numeric',
      });

      final orderItem = await OrderItem().query().where('order_item', '=', id).first();
      if (orderItem == null) {
        return Response.json({
          'message': 'Item pesanan tidak ditemukan.',
        }, 404);
      }

      final updateData = req.input();
      await OrderItem().query().where('order_item', '=', id).update(updateData);

      return Response.json({
        'message': 'Item pesanan berhasil diperbarui.',
        'data': updateData,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui item pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menghapus item pesanan berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final orderItem = await OrderItem().query().where('order_item', '=', id).first();
      if (orderItem == null) {
        return Response.json({
          'message': 'Item pesanan tidak ditemukan.',
        }, 404);
      }

      await OrderItem().query().where('order_item', '=', id).delete();

      return Response.json({
        'message': 'Item pesanan berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus item pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderItemController orderController = OrderItemController();
