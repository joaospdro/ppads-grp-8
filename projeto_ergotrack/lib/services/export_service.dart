import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class ExportService {
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  
  Future<File> exportToPdf(Map<String, Map<String, int>> stats, DateTime startDate, DateTime endDate) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Relatório de Atividades ErgoTrack', 
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Período: ${DateFormat('dd/MM/yyyy').format(startDate)} até ${DateFormat('dd/MM/yyyy').format(endDate)}'),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      _buildPdfCell('Tipo', isHeader: true),
                      _buildPdfCell('Realizadas', isHeader: true),
                      _buildPdfCell('Perdidas', isHeader: true),
                    ]
                  ),
                  ...stats.entries.map((entry) {
                    return pw.TableRow(
                      children: [
                        _buildPdfCell(entry.key),
                        _buildPdfCell(entry.value['completed'].toString()),
                        _buildPdfCell(entry.value['missed'].toString()),
                      ]
                    );
                  }),
                ]
              ),
            ]
          );
        }
      )
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/relatorio_ergotrack.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
  
  pw.Widget _buildPdfCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: isHeader ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
      ),
    );
  }
  
  Future<File> exportToCsv(Map<String, Map<String, int>> stats) async {
    List<List<dynamic>> rows = [];
    
    rows.add(['Tipo', 'Realizadas', 'Perdidas']);
    
    stats.forEach((type, values) {
      rows.add([
        type, 
        values['completed'], 
        values['missed']
      ]);
    });
    
    String csv = const ListToCsvConverter().convert(rows);
    
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/relatorio_ergotrack.csv');
    await file.writeAsString(csv);
    return file;
  }
  
  Future<void> shareFile(File file) async {
    final xfile = XFile(file.path);
    await Share.shareXFiles([xfile]);
  }
}