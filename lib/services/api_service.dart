import 'package:dio/dio.dart';
import 'package:product_crud_app/models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<Product>> fetchProducts({
    String? search,
    String? sortBy = 'Name',
    String sortOrder = 'A to Z', 
    int? page,
    int pageSize = 10,
  }) async {
    final response = await _dio.get('/products');
    if (response.statusCode == 200){
      final data = response.data;
      if (data is List){
        return data.map<Product>((e) => Product.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        return [Product.fromJson(data)];
      }
      return [];
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> addProduct(Product product) async {
    final response = await _dio.post('/products', data: product.toJson());
    if (response.statusCode == 201){
      return Product.fromJson(response.data);
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final response = await _dio.put('/products', queryParameters: {'id': product.id}, data: product.toJson());
    if (response.statusCode == 200){
      return Product.fromJson(response.data);
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await _dio.delete('/products', queryParameters: {'id': id});
    if (response.statusCode != 200){
      throw Exception('Failed to delete product');
    }
  }
}