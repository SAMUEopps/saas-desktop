/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/record_model.dart';

class RecordsTable extends StatelessWidget {
  final List<Record> records;
  final bool isAdmin;
  final bool sortAscending;
  final int sortColumnIndex;
  final Function(int, bool) onSort;
  final Function(String) onDeleteRecord;

  const RecordsTable({
    super.key,
    required this.records,
    required this.isAdmin,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onDeleteRecord,
  });

  String _getRecordType(Record record) {
    if ((record.invoiceNo ?? '').isNotEmpty) return 'Delivery';
    if ((record.cashSaleNo ?? '').isNotEmpty) return 'Cash Sale';
    if ((record.quotationNo ?? '').isNotEmpty) return 'Quotation';
    return 'Unknown';
  }

  String _getRecordNumber(Record record) {
    if ((record.invoiceNo ?? '').isNotEmpty) return record.invoiceNo ?? '';
    if ((record.cashSaleNo ?? '').isNotEmpty) return record.cashSaleNo ?? '';
    if ((record.quotationNo ?? '').isNotEmpty) return record.quotationNo ?? '';
    return 'N/A';
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Delivery':
        return Colors.blue.shade100;
      case 'Cash Sale':
        return Colors.green.shade100;
      case 'Quotation':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getTypeTextColor(String type) {
    switch (type) {
      case 'Delivery':
        return Colors.blue.shade800;
      case 'Cash Sale':
        return Colors.green.shade800;
      case 'Quotation':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: records.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No records found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardTheme: const CardTheme(elevation: 0),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue.shade50),
                    columnSpacing: 24,
                    horizontalMargin: 12,
                    sortAscending: sortAscending,
                    sortColumnIndex: sortColumnIndex,
                    columns: [
                      DataColumn(
                        label: const Text('Date',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Time',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Customer',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Type',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Number',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Facilitator',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Created By',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      if (isAdmin)
                        const DataColumn(
                          label: Text('Actions',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                    ],
                    rows: records.map((record) {
                      String recordType = _getRecordType(record);
                      String recordNumber = _getRecordNumber(record);
                      Color typeColor = _getTypeColor(recordType);
                      Color typeTextColor = _getTypeTextColor(recordType);

                      return DataRow(
                        cells: [
                          DataCell(Text(DateFormat.yMd().format(record.date))),
                          DataCell(Text(DateFormat.Hm().format(record.time))),
                          DataCell(Text(record.customerName)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: typeColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                recordType,
                                style: TextStyle(
                                    color: typeTextColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          DataCell(Text(recordNumber)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                record.facilitator,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          DataCell(Text(
                            'Ksh ${record.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          )),
                          DataCell(Text(record.createdBy)),
                          if (isAdmin)
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        size: 18, color: Colors.blue),
                                    onPressed: () {
                                      // TODO: Edit functionality
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 18, color: Colors.red),
                                    onPressed: () =>
                                        onDeleteRecord(record.id),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/record_model.dart';

class RecordsTable extends StatelessWidget {
  final List<Record> records;
  final bool isAdmin;
  final bool sortAscending;
  final int sortColumnIndex;
  final Function(int, bool) onSort;
  final Function(String) onDeleteRecord;
  final Function(Record) onEditRecord; // Add this callback

  const RecordsTable({
    super.key,
    required this.records,
    required this.isAdmin,
    required this.sortAscending,
    required this.sortColumnIndex,
    required this.onSort,
    required this.onDeleteRecord,
    required this.onEditRecord, // Add this parameter
  });

  String _getRecordType(Record record) {
    if ((record.invoiceNo ?? '').isNotEmpty) return 'Delivery';
    if ((record.cashSaleNo ?? '').isNotEmpty) return 'Cash Sale';
    if ((record.quotationNo ?? '').isNotEmpty) return 'Quotation';
    return 'Unknown';
  }

  String _getRecordNumber(Record record) {
    if ((record.invoiceNo ?? '').isNotEmpty) return record.invoiceNo ?? '';
    if ((record.cashSaleNo ?? '').isNotEmpty) return record.cashSaleNo ?? '';
    if ((record.quotationNo ?? '').isNotEmpty) return record.quotationNo ?? '';
    return 'N/A';
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Delivery':
        return Colors.blue.shade100;
      case 'Cash Sale':
        return Colors.green.shade100;
      case 'Quotation':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getTypeTextColor(String type) {
    switch (type) {
      case 'Delivery':
        return Colors.blue.shade800;
      case 'Cash Sale':
        return Colors.green.shade800;
      case 'Quotation':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: records.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No records found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardTheme: const CardTheme(elevation: 0),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue.shade50),
                    columnSpacing: 24,
                    horizontalMargin: 12,
                    sortAscending: sortAscending,
                    sortColumnIndex: sortColumnIndex,
                    columns: [
                      DataColumn(
                        label: const Text('Date',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Time',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Customer',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Type',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Number',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Facilitator',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      DataColumn(
                        label: const Text('Created By',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: onSort,
                      ),
                      if (isAdmin)
                        const DataColumn(
                          label: Text('Actions',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                    ],
                    rows: records.map((record) {
                      String recordType = _getRecordType(record);
                      String recordNumber = _getRecordNumber(record);
                      Color typeColor = _getTypeColor(recordType);
                      Color typeTextColor = _getTypeTextColor(recordType);

                      return DataRow(
                        cells: [
                          DataCell(Text(DateFormat.yMd().format(record.date))),
                          DataCell(Text(DateFormat.Hm().format(record.time))),
                          DataCell(Text(record.customerName)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: typeColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                recordType,
                                style: TextStyle(
                                    color: typeTextColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          DataCell(Text(recordNumber)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                record.facilitator,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          DataCell(Text(
                            'Ksh ${record.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          )),
                          DataCell(Text(record.createdBy)),
                          if (isAdmin)
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        size: 18, color: Colors.blue),
                                    onPressed: () {
                                      // Call the edit callback with the current record
                                      onEditRecord(record);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 18, color: Colors.red),
                                    onPressed: () =>
                                        onDeleteRecord(record.id),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
