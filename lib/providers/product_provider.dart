import 'package:flutter/material.dart';
import 'package:product_crud_app/models/product.dart';
import 'package:product_crud_app/services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = []; // Store all products from backend
  List<Product> _products = [];
  bool _loading = false;
  String _search = '';
  String _sortBy = 'Name';
  String _sortOrder = 'A to Z'; // new: track sort order
  int _page = 1;
  int _pageSize = 10;
  bool _hasMore = true;

  List<Product> get products => _products;
  bool get loading => _loading;
  String get search => _search;
  String get sortBy => _sortBy;
  String get sortOrder => _sortOrder;
  int get page => _page;
  int get pageSize => _pageSize;
  bool get hasMore => _hasMore;
  int get totalFilteredCount {
    if (_allProducts.isEmpty) return 0;
    return _getFilteredAndSortedProducts().length;
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (_loading) return;
    _loading = true;
    notifyListeners();

    if (refresh) {
      _page = 1;
      _products = [];
      _hasMore = true;
    }

    try {
      // Only fetch from API if we don't have all products or if refreshing
      if (_allProducts.isEmpty || refresh) {
        _allProducts = await _apiService.fetchProducts(
          search: _search,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
          page: _page,
          pageSize: _pageSize,
        );
      }

      // Get filtered and sorted products
      List<Product> filteredAndSortedProducts = _getFilteredAndSortedProducts();

      // Handle pagination on filtered results
      int startIndex = (_page - 1) * _pageSize;
      int endIndex = startIndex + _pageSize;
      
      List<Product> pageProducts = [];
      if (startIndex < filteredAndSortedProducts.length) {
        endIndex = endIndex > filteredAndSortedProducts.length ? filteredAndSortedProducts.length : endIndex;
        pageProducts = filteredAndSortedProducts.sublist(startIndex, endIndex);
      }

      if (refresh) {
        _products = pageProducts;
      } else {
        _products.addAll(pageProducts);
      }
      
      // Check if there are more pages
      _hasMore = endIndex < filteredAndSortedProducts.length;
      
    } catch (e) {
      print('Error fetching products: $e');
    }
    _loading = false;
    notifyListeners();
  }

  List<Product> _getFilteredAndSortedProducts() {
    // Filter products based on search
    List<Product> filteredProducts = _allProducts;
    if (_search.isNotEmpty) {
      filteredProducts = _allProducts.where((product) {
        return product.name.toLowerCase().contains(_search.toLowerCase());
      }).toList();
    }

    // Apply sorting
    _applySorting(filteredProducts);
    return filteredProducts;
  }

  void setSearch(String search) {
    _search = search.trim(); // Trim whitespace
    _page = 1; // Reset page when searching
    _products = []; // Clear current products
    _hasMore = true; // Reset pagination
    loadProducts(refresh: true);
  }

  void setSortBy(String sortBy, String selectedSortOrder) {
    _sortBy = sortBy;
    _sortOrder = selectedSortOrder;
    _page = 1; // Reset page when sorting
    _products = []; // Clear current products  
    _hasMore = true; // Reset pagination
    loadProducts(refresh: true);
  }

  void nextPage() {
    if (_hasMore && !_loading) {
      _page++;
      loadProducts();
    }
  }

  void _applySorting(List<Product> products) {
    // Handles local sorting for UI
    int modifier = (_sortOrder == 'Z to A' || _sortOrder == 'Highest to Lowest') ? -1 : 1;
    if (_sortBy == 'Name') {
      products.sort((a, b) => a.name.compareTo(b.name) * modifier);
    } else if (_sortBy == 'Price') {
      products.sort((a, b) => a.price.compareTo(b.price) * modifier);
    } else if (_sortBy == 'Stock') {
      products.sort((a, b) => a.stock.compareTo(b.stock) * modifier);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _apiService.addProduct(product);
      loadProducts(refresh: true);
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _apiService.updateProduct(product);
      loadProducts(refresh: true);
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
      loadProducts(refresh: true);
    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}