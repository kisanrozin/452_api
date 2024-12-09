import 'package:vania/vania.dart';
import 'package:kedai_kopi/app/models/order.dart';

class OrderController extends Controller {
  // Mendapatkan semua data order
  Future<Response> index() async {
    try {
      final orders = await Order().query().get();
      return Response.json({
        'message': 'Daftar pesanan berhasil diambil.',
        'data': orders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil daftar pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menambahkan pesanan baru
  Future<Response> create(Request req) async {
    req.validate({
      'cust_id': 'required|numeric',
      'order_date': 'required|date',
    }, {
      'cust_id.required': 'ID pelanggan tidak boleh kosong.',
      'cust_id.numeric': 'ID pelanggan harus berupa angka.',
      'order_date.required': 'Tanggal pesanan tidak boleh kosong.',
      'order_date.date': 'Tanggal pesanan harus berupa format tanggal.',
    });

    final orderData = req.input();
    orderData['created_at'] = DateTime.now().toIso8601String();

    await Order().query().insert(orderData);

    return Response.json({
      'message': 'Pesanan berhasil ditambahkan.',
      'data': orderData,
    }, 201);
  }

  // Menampilkan pesanan berdasarkan ID
  Future<Response> show(Request req, int id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({
          'message': 'Pesanan tidak ditemukan.',
        }, 404);
      }

      return Response.json({
        'message': 'Pesanan ditemukan.',
        'data': order,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui pesanan berdasarkan ID
  Future<Response> update(Request req, int id) async {
    try {
      req.validate({
        'cust_id': 'numeric',
        'order_date': 'date',
      });

      final order = await Order().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({
          'message': 'Pesanan tidak ditemukan.',
        }, 404);
      }

      final updateData = req.input();
      await Order().query().where('order_num', '=', id).update(updateData);

      return Response.json({
        'message': 'Pesanan berhasil diperbarui.',
        'data': updateData,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui data pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menghapus pesanan berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();
      if (order == null) {
        return Response.json({
          'message': 'Pesanan tidak ditemukan.',
        }, 404);
      }

      await Order().query().where('order_num', '=', id).delete();

      return Response.json({
        'message': 'Pesanan berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus pesanan.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderController orderController = OrderController();
