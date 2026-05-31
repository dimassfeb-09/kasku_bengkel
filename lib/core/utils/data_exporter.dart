import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/service/domain/entities/service_order.dart';

class DataExporter {
  static Future<String> exportToCsv(List<ServiceOrder> orders) async {
    List<List<dynamic>> rows = [];
    rows.add([
      "ID",
      "Plat Nomor",
      "Pemilik",
      "Status",
      "Total Estimasi",
      "Keluhan",
      "Tanggal Dibuat"
    ]);

    for (var order in orders) {
      rows.add([
        order.id,
        order.vehicleInfo.plateNumber,
        order.vehicleInfo.ownerName,
        order.status.name,
        order.totalEstimation,
        order.complaint,
        order.createdAt.toIso8601String(),
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/laporan_servis_${DateTime.now().millisecondsSinceEpoch}.csv');
    
    await file.writeAsString(csvData);
    return file.path;
  }

  static Future<String> exportToExcel(List<ServiceOrder> orders) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Laporan Servis'];

    sheetObject.appendRow([
      TextCellValue("ID"),
      TextCellValue("Plat Nomor"),
      TextCellValue("Pemilik"),
      TextCellValue("Status"),
      TextCellValue("Total Estimasi"),
      TextCellValue("Keluhan"),
      TextCellValue("Tanggal Dibuat")
    ]);

    for (var order in orders) {
      sheetObject.appendRow([
        TextCellValue(order.id),
        TextCellValue(order.vehicleInfo.plateNumber),
        TextCellValue(order.vehicleInfo.ownerName),
        TextCellValue(order.status.name),
        DoubleCellValue(order.totalEstimation),
        TextCellValue(order.complaint),
        TextCellValue(order.createdAt.toIso8601String()),
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/laporan_servis_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final fileBytes = excel.save();
    
    if (fileBytes != null) {
      await File(filePath).writeAsBytes(fileBytes);
    }
    
    return filePath;
  }
}
