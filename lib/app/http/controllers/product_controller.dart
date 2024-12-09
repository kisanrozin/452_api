import 'dart:io';
import 'package:vania/vania.dart';
import 'package:kedai_kopi/app/models/product.dart';

class ProductController extends Controller {
  Future<Response> index() async {
    try {
      final products = await Product().query().get();
      return Response.json({
        'message': 'Daftar produk berhasil diambil.',
        'data': products,
      });
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil daftar produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> create(Request req) async {
    req.validate({
      'prod_name': 'required|String',
      'prod_desc': 'required|String',
      'prod_price': 'required|numeric',
      'vend_id': 'required|numeric',
    }, {
      'prod_name.required': 'Nama produk tidak boleh kosong.',
      'prod_desc.required': 'Deskripsi produk tidak boleh kosong.',
      'prod_price.required': 'Harga produk tidak boleh kosong.',
      'vend_id.required': 'Vendor ID tidak boleh kosong.',
    });

    final dataProduct = req.input();
    dataProduct['created_at'] = DateTime.now().toIso8601String();

    final existingProduct = await Product()
        .query()
        .where('prod_name', '=', dataProduct['prod_name'])
        .first();
    if (existingProduct != null) {
      return Response.json({
        'message': 'Produk dengan nama ini sudah ada.',
      }, 409);
    }

    await Product().query().insert(dataProduct);

    return Response.json({
      'message': 'Produk berhasil ditambahkan.',
      'data': dataProduct,
    }, 201);
  }

  Future<Response> show(Request req, int id) async {
    try {
      final product = await Product().query().where('prod_id', '=', id).first();
      if (product == null) {
        return Response.json({'message': 'Produk tidak ditemukan.'}, 404);
      }

      return Response.json({
        'message': 'Produk ditemukan.',
        'data': product,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request req, int id) async {
    try {
      req.validate({
        'prod_name': 'String',
        'prod_desc': 'String',
        'prod_price': 'numeric',
        'vend_id': 'numeric',
      });

      final product = await Product().query().where('vend_id', '=', id).first();
      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      final updateData = req.input();
      await Product().query().where('vend_id', '=', id).update(updateData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': updateData,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal memperbarui produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      final product = await Product().query().where('vend_id', '=', id).first();
      if (product == null) {
        return Response.json({
          'message': 'Produk tidak ditemukan.',
        }, 404);
      }

      await Product().query().where('vend_id', '=', id).delete();

      return Response.json({'message': 'Produk berhasil dihapus.'}, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal menghapus produk.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductController productController = ProductController();
