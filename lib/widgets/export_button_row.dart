import 'package:flutter/material.dart';

class ExportButtonRow extends StatelessWidget {
  final VoidCallback onExportCSV;
  final VoidCallback onExportPDF;
  const ExportButtonRow({
    super.key,
    required this.onExportCSV,
    required this.onExportPDF,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.file_download),
          label: Text('Export CSV'),
          onPressed: onExportCSV,
        ),
        SizedBox(width: 12),
        ElevatedButton.icon(
          icon: Icon(Icons.picture_as_pdf),
          label: Text('Export PDF'),
          onPressed: onExportPDF,
        ),
      ],
    );
  }
}
