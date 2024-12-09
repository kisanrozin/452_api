import 'package:vania/vania.dart';
import 'package:kedai_kopi/app/models/customer.dart';

class CustomerController extends Controller {
  // Mendapatkan semua data customer
  Future<Response> index() async {
    try {
      final customers = await Customer().query().get();
      return Response.json({
        'message': 'Daftar pelanggan berhasil diambil.',
        'data': customers,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil daftar pelanggan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menambahkan data customer baru
  Future<Response> create(Request req) async {
    req.validate({
      'cust_name': 'required|String',
      'cust_address': 'required|String',
      'cust_city': 'required|String',
      'cust_state': 'required|String',
      'cust_zip': 'required|String',
      'cust_country': 'required|String',
      'cust_telp': 'required|String',
    }, {
      'cust_name.required': 'Nama pelanggan tidak boleh kosong.',
      'cust_address.required': 'Alamat tidak boleh kosong.',
      'cust_city.required': 'Kota tidak boleh kosong.',
      'cust_state.required': 'Negara bagian tidak boleh kosong.',
      'cust_zip.required': 'Kode pos tidak boleh kosong.',
      'cust_country.required': 'Negara tidak boleh kosong.',
      'cust_telp.required': 'Nomor telepon tidak boleh kosong.',
    });

    final customerData = req.input();
    customerData['created_at'] = DateTime.now().toIso8601String();

    await Customer().query().insert(customerData);

    return Response.json({
      'message': 'Pelanggan berhasil ditambahkan.',
      'data': customerData,
    }, 201);
  }

  // Menampilkan data customer berdasarkan ID
  Future<Response> show(Request req, int id) async {
    try {
      final customer = await Customer().query().where('cust_id', '=', id).first();
      if (customer == null) {
        return Response.json({
          'message': 'Pelanggan tidak ditemukan.',
        }, 404);
      }

      return Response.json({
        'message': 'Pelanggan ditemukan.',
        'data': customer,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data pelanggan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui data customer berdasarkan ID
  Future<Response> update(Request req, int id) async {
    try {
      req.validate({
        'cust_name': 'String',
        'cust_address': 'String',
        'cust_city': 'String',
        'cust_state': 'String',
        'cust_zip': 'String',
        'cust_country': 'String',
        'cust_telp': 'String',
      });

      final customer = await Customer().query().where('cust_id', '=', id).first();
      if (customer == null) {
        return Response.json({
          'message': 'Pelanggan tidak ditemukan.',
        }, 404);
      }

      final updateData = req.input();
      await Customer().query().where('cust_id', '=', id).update(updateData);

      return Response.json({
        'message': 'Pelanggan berhasil diperbarui.',
        'data': updateData,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat memperbarui data pelanggan.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menghapus data customer berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final customer = await Customer().query().where('cust_id', '=', id).first();
      if (customer == null) {
        return Response.json({
          'message': 'Pelanggan tidak ditemukan.',
        }, 404);
      }

      await Customer().query().where('cust_id', '=', id).delete();

      return Response.json({
        'message': 'Pelanggan berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus data pelanggan.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final CustomerController customerController = CustomerController();
