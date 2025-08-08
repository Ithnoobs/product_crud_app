import 'package:flutter/material.dart';
import 'package:product_crud_app/models/product.dart';
import 'package:product_crud_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  bool _loading = false;

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
        title: Text('Add Product'),
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
                validator: (value) => value == null || value.isEmpty ? 'Please enter a product name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Product Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a product price';
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) return 'Please enter a valid price';
                  return null; 
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Product Stock'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a product stock';
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) return 'Please enter a valid stock';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _loading
              ? const Center(
                child: CircularProgressIndicator())
              : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false){
                    setState(() => _loading = true);
                    try {
                      await provider.addProduct(
                        Product(
                          id: 0,
                          name: _nameController.text.trim(),
                          price: double.tryParse(_priceController.text) ?? 0,
                          stock: int.tryParse(_stockController.text) ?? 0,
                        )
                      );
                      if (mounted){
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding product: $e'))
                      );
                    } finally {
                      if (mounted) setState(() => _loading = false);
                    }
                  }
                },
                child: const Text('Add Product')
              )
            ],
          )
        )
      ),
    );
  }
}