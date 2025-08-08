import 'package:flutter/material.dart';
import 'package:product_crud_app/models/product.dart';
import 'package:product_crud_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _stockController.text = widget.product.stock.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  final price = double.tryParse(value);
                  if (price == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Product Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product stock';
                  }
                  final stock = int.tryParse(value);
                  if (stock == null) {
                    return 'Please enter a valid stock';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
              _loading 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false){
                    setState(() => _loading = true);
                    try {
                      await provider.updateProduct(Product(
                        id: widget.product.id,
                        name: _nameController.text.trim(),
                        price: double.parse(_priceController.text),
                        stock: int.parse(_stockController.text),
                      ));
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update product')),
                      );
                    } finally {
                      if (mounted) setState(() => _loading = false);
                    }
                  }
                },
                child: const Text('Update Product'),
              ),
            ],
          )
        )
      )
    );
  }
}