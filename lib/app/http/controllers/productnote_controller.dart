import 'package:vania/vania.dart';
import 'package:kedai_kopi/app/models/productnote.dart';

class ProductNoteController extends Controller {
  // Mendapatkan semua catatan produk
  Future<Response> index() async {
    try {
      final productNotes = await ProductNote().query().get();
      return Response.json({
        'message': 'Daftar catatan produk berhasil diambil.',
        'data': productNotes,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil daftar catatan produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menambahkan catatan baru untuk produk
  Future<Response> create(Request req) async {
    req.validate({
      'prod_id': 'required|numeric',
      'note_date': 'required|date',
      'note_text': 'required|String',
    }, {
      'prod_id.required': 'ID produk tidak boleh kosong.',
      'note_date.required': 'Tanggal catatan tidak boleh kosong.',
      'note_text.required': 'Isi catatan tidak boleh kosong.',
    });

    final productNoteData = req.input();
    productNoteData['created_at'] = DateTime.now().toIso8601String();

    await ProductNote().query().insert(productNoteData);

    return Response.json({
      'message': 'Catatan produk berhasil ditambahkan.',
      'data': productNoteData,
    }, 201);
  }

  // Menampilkan catatan produk berdasarkan ID
  Future<Response> show(Request req, int id) async {
    try {
      final productNote = await ProductNote().query().where('note_id', '=', id).first();
      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk tidak ditemukan.',
        }, 404);
      }

      return Response.json({
        'message': 'Catatan produk ditemukan.',
        'data': productNote,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil catatan produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui catatan produk berdasarkan ID
  Future<Response> update(Request req, int id) async {
    try {
      req.validate({
        'prod_id': 'numeric',
        'note_date': 'date',
        'note_text': 'String',
      });

      final productNote = await ProductNote().query().where('note_id', '=', id).first();
      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk tidak ditemukan.',
        }, 404);
      }

      final updateData = req.input();
      await ProductNote().query().where('note_id', '=', id).update(updateData);

      return Response.json({
        'message': 'Catatan produk berhasil diperbarui.',
        'data': updateData,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui catatan produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menghapus catatan produk berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final productNote = await ProductNote().query().where('note_id', '=', id).first();
      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk tidak ditemukan.',
        }, 404);
      }

      await ProductNote().query().where('note_id', '=', id).delete();

      return Response.json({
        'message': 'Catatan produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus catatan produk.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductNoteController productNoteController = ProductNoteController();
