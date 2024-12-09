import 'package:vania/vania.dart';
import 'package:kedai_kopi/app/models/vendor.dart';

class VendorController extends Controller {
  // Mendapatkan semua data vendor
  Future<Response> index() async {
    try {
      final vendors = await Vendor().query().get();
      return Response.json({
        'message': 'Daftar vendor berhasil diambil.',
        'data': vendors,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil daftar vendor.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menambahkan vendor baru
  Future<Response> create(Request req) async {
    req.validate({
      'vend_name': 'required|String',
      'vend_address': 'required|String',
      'vend_kota': 'required|String',
      'vend_state': 'required|String',
      'vend_zip': 'required|String',
      'vend_country': 'required|String',
    }, {
      'vend_name.required': 'Nama vendor tidak boleh kosong.',
      'vend_address.required': 'Alamat vendor tidak boleh kosong.',
      'vend_kota.required': 'Kota vendor tidak boleh kosong.',
      'vend_state.required': 'State vendor tidak boleh kosong.',
      'vend_zip.required': 'ZIP vendor tidak boleh kosong.',
      'vend_country.required': 'Negara vendor tidak boleh kosong.',
    });

    final vendorData = req.input();
    vendorData['created_at'] = DateTime.now().toIso8601String();

    await Vendor().query().insert(vendorData);

    return Response.json({
      'message': 'Vendor berhasil ditambahkan.',
      'data': vendorData,
    }, 201);
  }

  // Menampilkan vendor berdasarkan ID
  Future<Response> show(Request req, int id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor tidak ditemukan.',
        }, 404);
      }

      return Response.json({
        'message': 'Vendor ditemukan.',
        'data': vendor,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data vendor.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui data vendor berdasarkan ID
  Future<Response> update(Request req, int id) async {
    try {
      req.validate({
        'vend_name': 'String',
        'vend_address': 'String',
        'vend_kota': 'String',
        'vend_state': 'String',
        'vend_zip': 'String',
        'vend_country': 'String',
      });

      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor tidak ditemukan.',
        }, 404);
      }

      final updateData = req.input();
      await Vendor().query().where('vend_id', '=', id).update(updateData);

      return Response.json({
        'message': 'Vendor berhasil diperbarui.',
        'data': updateData,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui data vendor.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menghapus vendor berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final vendor = await Vendor().query().where('vend_id', '=', id).first();
      if (vendor == null) {
        return Response.json({
          'message': 'Vendor tidak ditemukan.',
        }, 404);
      }

      await Vendor().query().where('vend_id', '=', id).delete();

      return Response.json({
        'message': 'Vendor berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus vendor.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final VendorController vendorController = VendorController();
