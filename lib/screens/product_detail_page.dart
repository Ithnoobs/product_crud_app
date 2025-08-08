import 'package:flutter/material.dart';
import 'package:product_crud_app/models/product.dart';
import 'package:product_crud_app/widgets/export_button_row.dart';
import 'package:product_crud_app/services/export_service.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  Future<void> _exportCSV(BuildContext context) async {
    try {
      final path = await ExportService.exportProductToCSV(product);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV exported to $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export CSV: $e')),
        );
      }
    }
  }

  Future<void> _exportPDF(BuildContext context) async {
    try {
      final path = await ExportService.exportProductToPDF(product);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF exported to $path')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export PDF: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(product.name, style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Price:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${product.price}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Stock:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${product.stock}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 32),
            ExportButtonRow(
              onExportCSV: () => _exportCSV(context),
              onExportPDF: () => _exportPDF(context),
            ),
          ],
        ),
      ),
    );
  }
}
