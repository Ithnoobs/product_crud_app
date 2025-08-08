import 'package:flutter/material.dart';
import 'package:product_crud_app/providers/product_provider.dart';
import 'package:product_crud_app/screens/add_product_page.dart';
import 'package:product_crud_app/screens/edit_product_page.dart';
import 'package:provider/provider.dart';
import 'package:product_crud_app/widgets/sort_dropdown_row.dart';
import 'package:product_crud_app/widgets/search_bar.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();

  ProductProvider get provider => Provider.of<ProductProvider>(context, listen: false);

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadProducts(refresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (provider.hasMore && !provider.loading) {
          provider.nextPage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  final sortOptions = ['Name', 'Price', 'Stock'];
  final sortOrders = {
    'Name': ['A to Z', 'Z to A'],
    'Price': ['Lowest to Highest', 'Highest to Lowest'],
    'Stock': ['Lowest to Highest', 'Highest to Lowest'],
  };

    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => RefreshIndicator(
          onRefresh: () => provider.loadProducts(refresh: true),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(
                  hintText: 'Search products...',
                  onChanged: (query) => provider.setSearch(query),
                ),
              ),
              // Sort field and order dropdowns
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: SortDropdownRow(
                  sortFields: sortOptions,
                  sortOrders: sortOrders,
                  selectedSortField: provider.sortBy,
                  selectedSortOrder: provider.sortOrder,
                  onSortFieldChanged: (field) {
                    final defaultOrder = sortOrders[field]?.first ?? '';
                    provider.setSortBy(field, defaultOrder);
                  },
                  onSortOrderChanged: (order) {
                    provider.setSortBy(provider.sortBy, order);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.products.length + (provider.hasMore || provider.loading ? 1 : (provider.products.isNotEmpty ? 1 : 0)),
                  itemBuilder: (context, index) {
                    if (index < provider.products.length){
                      final product = provider.products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('${product.price}\$, Stock: ${product.stock}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Product'),
                                content: Text('Are you sure you want to delete ${product.name}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context, true);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true){
                              await provider.deleteProduct(product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.name} deleted')),
                              );
                            }
                          }
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProductPage(product: product),
                            ),
                          );
                        },
                      );
                    } else {
                      // Show different indicators based on state
                      if (provider.loading && provider.hasMore) {
                        // Loading more items
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (!provider.hasMore && provider.products.isNotEmpty) {
                        // End of pages indicator
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.grey[600],
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'End of pages',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'You\'ve reached the end of all products',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddProductPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}