import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../features/cashier/domain/entities/payment_transaction.dart';
import '../../features/service/domain/entities/service_order.dart';

class PdfGenerator {
  static Future<void> generateReceipt({
    required PaymentTransaction transaction,
    required ServiceOrder order,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('KASIRKU BENGKEL', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Divider(),
              pw.Text('Plat Nomor: ${order.vehicleInfo.plateNumber}'),
              pw.Text('Pemilik: ${order.vehicleInfo.ownerName}'),
              pw.Text('Tanggal: ${transaction.transactionDate.toString().split('.')[0]}'),
              pw.Divider(),
              pw.Text('Rincian:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...order.items.map((item) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(item.when(labor: (n, _) => n, part: (n, q, _) => '$n (x$q)')),
                      pw.Text('Rp ${item.subtotal.toStringAsFixed(0)}'),
                    ],
                  )),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rp ${transaction.totalAmount.toStringAsFixed(0)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('BAYAR'),
                  pw.Text('Rp ${transaction.amountPaid.toStringAsFixed(0)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('KEMBALI'),
                  pw.Text('Rp ${transaction.changeAmount.toStringAsFixed(0)}'),
                ],
              ),
              pw.Divider(),
              pw.Center(child: pw.Text('Terima Kasih')),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
