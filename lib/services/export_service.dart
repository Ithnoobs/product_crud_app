import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui';
import '../models/product.dart';

class ExportService {
  static Future<String> _getDownloadsPath() async {
    final Directory dir = Directory('/storage/emulated/0/Download');
    if (await dir.exists()) {
      return dir.path;
    }
    return (await getApplicationDocumentsDirectory()).path;
  }

  static Future<String> exportProductToCSV(Product product) async {
    final List<List<dynamic>> rows = [
      ['Product Export', '', '', ''],
      ['ID', 'Name', 'Price', 'Stock'],
      [
        product.id,
        '"${product.name.replaceAll('"', '""')}"', // Quote and escape
        product.price.toStringAsFixed(2),
        product.stock
      ],
    ];
    String csvData = const ListToCsvConverter().convert(rows);

    final downloadsPath = await _getDownloadsPath();
    final path = '$downloadsPath/product_${product.id}.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    if (kDebugMode) {
      print('CSV exported to: $path');
    }
    return path;
  }

  static Future<String> exportProductToPDF(Product product) async {
    final PdfDocument document = PdfDocument();
    final page = document.pages.add();

    const double margin = 36;
    double y = margin;

    // Title
    final titleFont = PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);
    final title = 'Product CRUD APP';
    final titleSize = titleFont.measureString(title);
    page.graphics.drawString(
      title,
      titleFont,
      bounds: Rect.fromLTWH(
        (page.getClientSize().width - titleSize.width) / 2,
        y,
        titleSize.width,
        titleSize.height,
      ),
    );
    y += titleSize.height + 20;

    final table = PdfGrid();
    table.columns.add(count: 2);

    final headerStyle = PdfGridCellStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
      cellPadding: PdfPaddings(left: 8, top: 6, right: 8, bottom: 6),
    );
    final valueStyle = PdfGridCellStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 14),
      cellPadding: PdfPaddings(left: 8, top: 6, right: 8, bottom: 6),
    );

    final details = [
      ['ID', product.id.toString()],
      ['Name', product.name],
      ['Price', product.price.toStringAsFixed(2)],
      ['Stock', product.stock.toString()],
    ];

    for (final row in details) {
      final gridRow = table.rows.add();
      gridRow.cells[0].value = row[0];
      gridRow.cells[1].value = row[1];
      gridRow.cells[0].style = headerStyle;
      gridRow.cells[1].style = valueStyle;
    }

    table.draw(
      page: page,
      bounds: Rect.fromLTWH(margin, y, page.getClientSize().width - 2 * margin, 0),
    );

    final now = DateTime.now();
    final footerFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.italic);
    final footerText = 'Exported: ${now.toLocal()}';
    page.graphics.drawString(
      footerText,
      footerFont,
      bounds: Rect.fromLTWH(
        margin,
        page.getClientSize().height - margin + 8,
        page.getClientSize().width - 2 * margin,
        16,
      ),
    );

    final List<int> bytes = await document.save();
    document.dispose();

    final downloadsPath = await _getDownloadsPath();
    final path = '$downloadsPath/product_${product.id}.pdf';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    if (kDebugMode) {
      print('PDF exported to: $path');
    }
    return path;
  }
}