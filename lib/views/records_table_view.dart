/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/user_model.dart';
import '../models/record_model.dart';

class RecordsTableView extends StatelessWidget {
  const RecordsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final records = Provider.of<RecordController>(context);
    final isAdmin = auth.currentUser?.role == UserRole.admin;
    final isStoreManager = auth.currentUser?.role == UserRole.storeManager;
    final isFacilitator = auth.currentUser?.role == UserRole.facilitator;

    List<Record> displayRecords = records.records;
    if (isFacilitator) {
      displayRecords = records.getRecordsForFacilitator(auth.currentUser!.name);
    }

    return Container(
      color: const Color(0xFFF0F0F0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0), // Adjust as needed
                child: Text(
                  isFacilitator ? 'Assigned Goods' : 'All Records',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: constraints.maxHeight - 100, // Adjust as needed
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: displayRecords.isEmpty
                    ? const Center(
                        child: Text(
                          'No records found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  cardTheme: CardTheme(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                ),
                                child: DataTable(
                                  headingRowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.blue.shade50),
                                  columns: [
                                    const DataColumn(
                                        label: Text('Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Customer',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Number',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Facilitator',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Amount',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Created By',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    if (isAdmin || isStoreManager)
                                      const DataColumn(
                                          label: Text('Actions',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))),
                                  ],
                                  rows: displayRecords.map((record) {
                                    String recordType;
                                    String recordNumber;

                                    if (record.invoiceNo.isNotEmpty) {
                                      recordType = 'Invoice';
                                      recordNumber = record.invoiceNo;
                                    } else if (record.cashSaleNo.isNotEmpty) {
                                      recordType = 'Cash Sale';
                                      recordNumber = record.cashSaleNo;
                                    } else if (record.quotationNo.isNotEmpty) {
                                      recordType = 'Quotation';
                                      recordNumber = record.quotationNo;
                                    } else {
                                      recordType = 'Unknown';
                                      recordNumber = 'N/A';
                                    }

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                            DateFormat.yMd().format(record.date))),
                                        DataCell(Text(
                                            DateFormat.Hm().format(record.time))),
                                        DataCell(Text(record.customerName)),
                                        DataCell(Text(recordType)),
                                        DataCell(Text(recordNumber)),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(record.facilitator),
                                          ),
                                        ),
                                        DataCell(Text(
                                            '\Ksh ${record.amount.toStringAsFixed(2)}')),
                                        DataCell(Text(record.createdBy)),
                                        if (isAdmin || isStoreManager)
                                          DataCell(
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      size: 18, color: Colors.blue),
                                                  onPressed: () {
                                                    // Edit functionality
                                                  },
                                                ),
                                                if (isAdmin)
                                                  IconButton(
                                                    icon: const Icon(Icons.delete,
                                                        size: 18, color: Colors.red),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                              title: const Text(
                                                                  'Delete Record'),
                                                              content: const Text(
                                                                  'Are you sure you want to delete this record?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () {
                                                                    records.deleteRecord(
                                                                        record.id!);
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors.red,
                                                                  ),
                                                                  child: const Text(
                                                                      'Delete'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                    },
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
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/user_model.dart';
import '../models/record_model.dart';

class RecordsTableView extends StatelessWidget {
  const RecordsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final records = Provider.of<RecordController>(context);
    final isAdmin = auth.currentUser?.role == UserRole.admin;
    final isFacilitator = auth.currentUser?.role == UserRole.facilitator;

    List<Record> displayRecords = records.records;
    if (isFacilitator) {
      displayRecords = records.getRecordsForFacilitator(auth.currentUser!.name);
    }

    return Container(
      color: const Color(0xFFF0F0F0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0), // Adjust as needed
                child: Text(
                  isFacilitator ? 'Assigned Goods' : 'All Records',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: constraints.maxHeight - 100, // Adjust as needed
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: displayRecords.isEmpty
                    ? const Center(
                        child: Text(
                          'No records found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  cardTheme: CardTheme(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                ),
                                child: DataTable(
                                  headingRowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.blue.shade50),
                                  columns: [
                                    const DataColumn(
                                        label: Text('Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Customer',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Number',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Facilitator',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Amount',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Created By',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    if (isAdmin)
                                      const DataColumn(
                                          label: Text('Actions',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))),
                                  ],
                                  rows: displayRecords.map((record) {
                                    String recordType;
                                    String recordNumber;

                                    if (record.invoiceNo.isNotEmpty) {
                                      recordType = 'Invoice';
                                      recordNumber = record.invoiceNo;
                                    } else if (record.cashSaleNo.isNotEmpty) {
                                      recordType = 'Cash Sale';
                                      recordNumber = record.cashSaleNo;
                                    } else if (record.quotationNo.isNotEmpty) {
                                      recordType = 'Quotation';
                                      recordNumber = record.quotationNo;
                                    } else {
                                      recordType = 'Unknown';
                                      recordNumber = 'N/A';
                                    }

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                            DateFormat.yMd().format(record.date))),
                                        DataCell(Text(
                                            DateFormat.Hm().format(record.time))),
                                        DataCell(Text(record.customerName)),
                                        DataCell(Text(recordType)),
                                        DataCell(Text(recordNumber)),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(record.facilitator),
                                          ),
                                        ),
                                        DataCell(Text(
                                            '\Ksh ${record.amount.toStringAsFixed(2)}')),
                                        DataCell(Text(record.createdBy)),
                                        if (isAdmin)
                                          DataCell(
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      size: 18, color: Colors.blue),
                                                  onPressed: () {
                                                    // Edit functionality
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      size: 18, color: Colors.red),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Delete Record'),
                                                            content: const Text(
                                                                'Are you sure you want to delete this record?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  records.deleteRecord(
                                                                      record.id!);
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.red,
                                                                ),
                                                                child: const Text(
                                                                    'Delete'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                  },
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
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/user_model.dart';
import '../models/record_model.dart';

class RecordsTableView extends StatelessWidget {
  const RecordsTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final records = Provider.of<RecordController>(context);
    final isAdmin = auth.currentUser?.role == UserRole.admin;
    final isFacilitator = auth.currentUser?.role == UserRole.facilitator;

    List<Record> displayRecords = records.records;
    if (isFacilitator) {
      displayRecords = records.getRecordsForFacilitator(auth.currentUser!.name);
    }

    return Container(
      color: const Color(0xFFF0F0F0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0), // Adjust as needed
                child: Text(
                  isFacilitator ? 'Assigned Goods' : 'All Records',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: constraints.maxHeight - 100, // Adjust as needed
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: displayRecords.isEmpty
                    ? const Center(
                        child: Text(
                          'No records found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  cardTheme: CardTheme(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                ),
                                child: DataTable(
                                  headingRowColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.blue.shade50),
                                  columns: [
                                    const DataColumn(
                                        label: Text('Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Customer',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Type',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Number',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Facilitator',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Amount',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    const DataColumn(
                                        label: Text('Created By',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    if (isAdmin)
                                      const DataColumn(
                                          label: Text('Actions',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))),
                                  ],
                                  rows: displayRecords.map((record) {
                                    String recordType;
                                    String recordNumber;

                                    if ((record.invoiceNo ?? '').isNotEmpty) {
                                      recordType = 'Invoice';
                                      recordNumber = record.invoiceNo ?? '';
                                    } else if ((record.cashSaleNo ?? '').isNotEmpty) {
                                      recordType = 'Cash Sale';
                                      recordNumber = record.cashSaleNo ?? '';
                                    } else if ((record.quotationNo ?? '').isNotEmpty) {
                                      recordType = 'Quotation';
                                      recordNumber = record.quotationNo ?? '';
                                    } else {
                                      recordType = 'Unknown';
                                      recordNumber = 'N/A';
                                    }

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                            DateFormat.yMd().format(record.date))),
                                        DataCell(Text(
                                            DateFormat.Hm().format(record.time))),
                                        DataCell(Text(record.customerName)),
                                        DataCell(Text(recordType)),
                                        DataCell(Text(recordNumber)),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(record.facilitator),
                                          ),
                                        ),
                                        DataCell(Text(
                                            '\Ksh ${record.amount.toStringAsFixed(2)}')),
                                        DataCell(Text(record.createdBy)),
                                        if (isAdmin)
                                          DataCell(
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      size: 18, color: Colors.blue),
                                                  onPressed: () {
                                                    // Edit functionality
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      size: 18, color: Colors.red),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Delete Record'),
                                                            content: const Text(
                                                                'Are you sure you want to delete this record?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  records.deleteRecord(
                                                                      record.id);
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.red,
                                                                ),
                                                                child: const Text(
                                                                    'Delete'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                  },
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
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}