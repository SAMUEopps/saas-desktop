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
}*/

/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/user_model.dart';
import '../models/record_model.dart';

class RecordsTableView extends StatefulWidget {
  const RecordsTableView({super.key});

  @override
  State<RecordsTableView> createState() => _RecordsTableViewState();
}

class _RecordsTableViewState extends State<RecordsTableView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  double _minAmount = 0;
  double _maxAmount = 100000;
  String? _selectedDocumentType;
  String? _selectedFacilitator;
  String? _selectedCreatedBy;
  bool _sortAscending = true;
  int _sortColumnIndex = 0; // Default sort by date

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Record> _filterRecords(List<Record> records, AuthController auth) {
    bool isFacilitator = auth.currentUser?.role == UserRole.facilitator;
    
    // Apply initial facilitator filter if needed
    List<Record> filtered = isFacilitator
        ? records.where((r) => r.facilitator == auth.currentUser!.name).toList()
        : List.from(records);

    // Apply search text filter
    if (_searchText.isNotEmpty) {
      filtered = filtered.where((record) {
        return record.customerName.toLowerCase().contains(_searchText) ||
            (record.invoiceNo?.toLowerCase().contains(_searchText) ?? false) ||
            (record.cashSaleNo?.toLowerCase().contains(_searchText) ?? false) ||
            (record.quotationNo?.toLowerCase().contains(_searchText) ?? false) ||
            record.facilitator.toLowerCase().contains(_searchText) ||
            record.createdBy.toLowerCase().contains(_searchText);
      }).toList();
    }

    // Apply document type filter
    if (_selectedDocumentType != null) {
      filtered = filtered.where((record) {
        if (_selectedDocumentType == 'Invoice') {
          return record.invoiceNo?.isNotEmpty ?? false;
        } else if (_selectedDocumentType == 'Cash Sale') {
          return record.cashSaleNo?.isNotEmpty ?? false;
        } else if (_selectedDocumentType == 'Quotation') {
          return record.quotationNo?.isNotEmpty ?? false;
        }
        return true;
      }).toList();
    }

    // Apply date range filter
    if (_fromDate != null || _toDate != null) {
      filtered = filtered.where((record) {
        final recordDate = record.date;
        bool afterFrom = _fromDate == null || recordDate.isAfter(_fromDate!);
        bool beforeTo = _toDate == null || recordDate.isBefore(_toDate!.add(const Duration(days: 1))); // Include entire toDate day
        return afterFrom && beforeTo;
      }).toList();
    }

    // Apply amount range filter
    filtered = filtered.where((record) {
      return record.amount >= _minAmount && record.amount <= _maxAmount;
    }).toList();

    // Apply facilitator filter
    if (_selectedFacilitator != null) {
      filtered = filtered.where((record) {
        return record.facilitator == _selectedFacilitator;
      }).toList();
    }

    // Apply createdBy filter
    if (_selectedCreatedBy != null) {
      filtered = filtered.where((record) {
        return record.createdBy == _selectedCreatedBy;
      }).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int compareResult;
      switch (_sortColumnIndex) {
        case 0: // Date
          compareResult = a.date.compareTo(b.date);
          break;
        case 1: // Time
          compareResult = a.time.compareTo(b.time);
          break;
        case 2: // Customer
          compareResult = a.customerName.compareTo(b.customerName);
          break;
        case 3: // Type
          compareResult = _getRecordType(a).compareTo(_getRecordType(b));
          break;
        case 4: // Number
          compareResult = _getRecordNumber(a).compareTo(_getRecordNumber(b));
          break;
        case 5: // Facilitator
          compareResult = a.facilitator.compareTo(b.facilitator);
          break;
        case 6: // Amount
          compareResult = a.amount.compareTo(b.amount);
          break;
        case 7: // Created By
          compareResult = a.createdBy.compareTo(b.createdBy);
          break;
        default:
          compareResult = a.date.compareTo(b.date);
      }
      return _sortAscending ? compareResult : -compareResult;
    });

    return filtered;
  }

  String _getRecordType(Record record) {
    if ((record.invoiceNo ?? '').isNotEmpty) return 'Invoice';
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

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate ?? DateTime.now() : _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(picked)) {
            _toDate = null;
          }
        } else {
          _toDate = picked;
          if (_fromDate != null && _fromDate!.isAfter(picked)) {
            _fromDate = null;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final records = Provider.of<RecordController>(context);
    final isAdmin = auth.currentUser?.role == UserRole.admin;
    final isFacilitator = auth.currentUser?.role == UserRole.facilitator;

    // Get unique facilitators and creators for dropdowns
    final facilitators = records.records.map((r) => r.facilitator).toSet().toList();
    final creators = records.records.map((r) => r.createdBy).toSet().toList();

    List<Record> displayRecords = _filterRecords(records.records, auth);

    return Container(
      color: const Color(0xFFF0F0F0),
      child: LayoutBuilder(
  builder: (context, constraints) {
    return Flexible( // Wrap the Column in a Flexible widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Allow the Column to shrink-wrap its children
        children: [
          // Header with title and search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  isFacilitator ? 'Assigned Goods' : 'All Records',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                ),
                const SizedBox(width: 16),
                Flexible( // Use Flexible instead of Expanded
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search records...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter controls
          Card(
            margin: const EdgeInsets.all(8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // First row of filters
                  Row(
                    children: [
                      Flexible( // Use Flexible instead of Expanded
                        child: DropdownButtonFormField<String>(
                          value: _selectedDocumentType,
                          decoration: InputDecoration(
                            labelText: 'Document Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: null, child: Text('All Types')),
                            DropdownMenuItem(value: 'Invoice', child: Text('Invoice')),
                            DropdownMenuItem(value: 'Cash Sale', child: Text('Cash Sale')),
                            DropdownMenuItem(value: 'Quotation', child: Text('Quotation')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedDocumentType = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      Flexible( // Use Flexible instead of Expanded
                        child: DropdownButtonFormField<String>(
                          value: _selectedFacilitator,
                          decoration: InputDecoration(
                            labelText: 'Facilitator',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Facilitators')),
                            ...facilitators.map((facilitator) {
                              return DropdownMenuItem(
                                value: facilitator,
                                child: Text(facilitator),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedFacilitator = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      Flexible( // Use Flexible instead of Expanded
                        child: DropdownButtonFormField<String>(
                          value: _selectedCreatedBy,
                          decoration: InputDecoration(
                            labelText: 'Created By',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Creators')),
                            ...creators.map((creator) {
                              return DropdownMenuItem(
                                value: creator,
                                child: Text(creator),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCreatedBy = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Second row of filters (date range)
                  Row(
                    children: [
                      Flexible( // Use Flexible instead of Expanded
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'From Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_fromDate != null
                                    ? DateFormat.yMd().format(_fromDate!)
                                    : 'Select date'),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible( // Use Flexible instead of Expanded
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'To Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_toDate != null
                                    ? DateFormat.yMd().format(_toDate!)
                                    : 'Select date'),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _fromDate = null;
                            _toDate = null;
                          });
                        },
                        tooltip: 'Clear date filters',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Third row (amount range)
                  Row(
                    children: [
                      Flexible( // Use Flexible instead of Expanded
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Min Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _minAmount = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible( // Use Flexible instead of Expanded
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Max Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _maxAmount = double.tryParse(value) ?? 100000;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDocumentType = null;
                            _selectedFacilitator = null;
                            _selectedCreatedBy = null;
                            _fromDate = null;
                            _toDate = null;
                            _minAmount = 0;
                            _maxAmount = 100000;
                            _searchController.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Reset Filters'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Records table
          Flexible(
            child: Container(
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
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
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
                            sortAscending: _sortAscending,
                            sortColumnIndex: _sortColumnIndex,
                            columns: [
                              DataColumn(
                                label: const Text('Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              DataColumn(
                                label: const Text('Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              DataColumn(
                                label: const Text('Customer',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              DataColumn(
                                label: const Text('Type',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              DataColumn(
                                label: const Text('Number',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              DataColumn(
                                label: const Text('Facilitator',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              DataColumn(
                                label: const Text('Amount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              DataColumn(
                                label: const Text('Created By',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = columnIndex;
                                    _sortAscending = ascending;
                                  });
                                },
                              ),
                              if (isAdmin)
                                const DataColumn(
                                    label: Text('Actions',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                            ],
                            rows: displayRecords.map((record) {
                              String recordType = _getRecordType(record);
                              String recordNumber = _getRecordNumber(record);

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
        ],
      ),
    );
  },
),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/user_model.dart';
import '../models/record_model.dart';
import '../components/filter_controls.dart';
import '../components/records_table.dart';
import '../components/search_header.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';


class RecordsTableView extends StatefulWidget {
  const RecordsTableView({super.key});

  @override
  State<RecordsTableView> createState() => _RecordsTableViewState();
}

class _RecordsTableViewState extends State<RecordsTableView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  double _minAmount = 0;
  double _maxAmount = 100000;
  String? _selectedDocumentType;
  String? _selectedFacilitator;
  String? _selectedCreatedBy;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Record> _filterRecords(List<Record> records, AuthController auth) {
    bool isFacilitator = auth.currentUser?.role == UserRole.facilitator;
    
    List<Record> filtered = isFacilitator
        ? records.where((r) => r.facilitator == auth.currentUser!.name).toList()
        : List.from(records);

    if (_searchText.isNotEmpty) {
      filtered = filtered.where((record) {
        return record.customerName.toLowerCase().contains(_searchText) ||
            (record.invoiceNo?.toLowerCase().contains(_searchText) ?? false) ||
            (record.cashSaleNo?.toLowerCase().contains(_searchText) ?? false) ||
            (record.quotationNo?.toLowerCase().contains(_searchText) ?? false) ||
            record.facilitator.toLowerCase().contains(_searchText) ||
            record.createdBy.toLowerCase().contains(_searchText);
      }).toList();
    }

    if (_selectedDocumentType != null) {
      filtered = filtered.where((record) {
        if (_selectedDocumentType == 'Invoice') {
          return record.invoiceNo?.isNotEmpty ?? false;
        } else if (_selectedDocumentType == 'Cash Sale') {
          return record.cashSaleNo?.isNotEmpty ?? false;
        } else if (_selectedDocumentType == 'Quotation') {
          return record.quotationNo?.isNotEmpty ?? false;
        }
        return true;
      }).toList();
    }

    if (_fromDate != null || _toDate != null) {
      filtered = filtered.where((record) {
        final recordDate = record.date;
        bool afterFrom = _fromDate == null || recordDate.isAfter(_fromDate!);
        bool beforeTo = _toDate == null || recordDate.isBefore(_toDate!.add(const Duration(days: 1)));
        return afterFrom && beforeTo;
      }).toList();
    }

    filtered = filtered.where((record) {
      return record.amount >= _minAmount && record.amount <= _maxAmount;
    }).toList();

    if (_selectedFacilitator != null) {
      filtered = filtered.where((record) => record.facilitator == _selectedFacilitator).toList();
    }

    if (_selectedCreatedBy != null) {
      filtered = filtered.where((record) => record.createdBy == _selectedCreatedBy).toList();
    }

    filtered.sort((a, b) {
      int compareResult;
      switch (_sortColumnIndex) {
        case 0: compareResult = a.date.compareTo(b.date); break;
        case 1: compareResult = a.time.compareTo(b.time); break;
        case 2: compareResult = a.customerName.compareTo(b.customerName); break;
        case 3: compareResult = _getRecordType(a).compareTo(_getRecordType(b)); break;
        case 4: compareResult = _getRecordNumber(a).compareTo(_getRecordNumber(b)); break;
        case 5: compareResult = a.facilitator.compareTo(b.facilitator); break;
        case 6: compareResult = a.amount.compareTo(b.amount); break;
        case 7: compareResult = a.createdBy.compareTo(b.createdBy); break;
        default: compareResult = a.date.compareTo(b.date);
      }
      return _sortAscending ? compareResult : -compareResult;
    });

    return filtered;
  }

  String _getRecordType(Record record) {
    if ((record.invoiceNo ?? '').isNotEmpty) return 'Invoice';
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

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate ?? DateTime.now() : _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(picked)) {
            _toDate = null;
          }
        } else {
          _toDate = picked;
          if (_fromDate != null && _fromDate!.isAfter(picked)) {
            _fromDate = null;
          }
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedDocumentType = null;
      _selectedFacilitator = null;
      _selectedCreatedBy = null;
      _fromDate = null;
      _toDate = null;
      _minAmount = 0;
      _maxAmount = 100000;
      _searchController.clear();
    });
  }

  @override
Widget build(BuildContext context) {
  final auth = Provider.of<AuthController>(context);
  final records = Provider.of<RecordController>(context);
  final isFacilitator = auth.currentUser?.role == UserRole.facilitator;
  final isAdmin = auth.currentUser?.role == UserRole.admin;

  final facilitators = records.records.map((r) => r.facilitator).toSet().toList();
  final creators = records.records.map((r) => r.createdBy).toSet().toList();

  List<Record> displayRecords = _filterRecords(records.records, auth);

  return Container(
    color: const Color(0xFFF0F0F0),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchHeader(
                title: isFacilitator ? 'Assigned Goods' : 'All Records',
                searchController: _searchController,
              ),
              // Filter controls
              if (isAdmin) // Only show filter controls if the user is an admin
                Container(
                  color: Colors.grey.shade50, // Very light grey background
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          // First row of filters
                          Row(
                            children: [
                              FilterDropdown<String>(
                                label: 'Document Type',
                                value: _selectedDocumentType,
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('All Types')),
                                  DropdownMenuItem(value: 'Invoice', child: Text('Delivery')),
                                  DropdownMenuItem(value: 'Cash Sale', child: Text('Cash Sale')),
                                  DropdownMenuItem(value: 'Quotation', child: Text('Quotation')),
                                ],
                                onChanged: (value) => setState(() => _selectedDocumentType = value),
                              ),
                              const SizedBox(width: 8),
                              FilterDropdown<String>(
                                label: 'Facilitator',
                                value: _selectedFacilitator,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Facilitators')),
                                  ...facilitators.map((facilitator) => DropdownMenuItem(
                                    value: facilitator,
                                    child: Text(facilitator),
                                  )).toList(),
                                ],
                                onChanged: (value) => setState(() => _selectedFacilitator = value),
                              ),
                              const SizedBox(width: 8),
                              FilterDropdown<String>(
                                label: 'Created By',
                                value: _selectedCreatedBy,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Creators')),
                                  ...creators.map((creator) => DropdownMenuItem(
                                    value: creator,
                                    child: Text(creator),
                                  )).toList(),
                                ],
                                onChanged: (value) => setState(() => _selectedCreatedBy = value),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date range picker
                          DateRangePicker(
                            fromDate: _fromDate,
                            toDate: _toDate,
                            onDateSelected: _selectDate,
                            onClearDates: () => setState(() {
                              _fromDate = null;
                              _toDate = null;
                            }),
                          ),
                          const SizedBox(height: 12),

                          // Amount range and reset button
                          Row(
                            children: [
                              Expanded(
                                child: AmountRangeFilter(
                                  minAmount: _minAmount,
                                  maxAmount: _maxAmount,
                                  onMinAmountChanged: (value) => setState(() {
                                    _minAmount = double.tryParse(value) ?? 0;
                                  }),
                                  onMaxAmountChanged: (value) => setState(() {
                                    _maxAmount = double.tryParse(value) ?? 100000;
                                  }),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ResetFiltersButton(onPressed: _resetFilters),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Records table
              Flexible(
                child: RecordsTable(
                  records: displayRecords,
                  isAdmin: isAdmin,
                  sortAscending: _sortAscending,
                  sortColumnIndex: _sortColumnIndex,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                    });
                  },
                  onEditRecord: (record) {
                    // Show a dialog or navigate to a form with the record data
                    _showEditRecordDialog(context, record);
                  },
                  onDeleteRecord: (recordId) {
                    // Show a confirmation dialog before deleting the record
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Record'),
                        content: const Text('Are you sure you want to delete this record?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop(); // Close confirmation dialog

                              final recordController = Provider.of<RecordController>(context, listen: false);
                              final dbService = DbService.instance;
                              final apiService = ApiService();

                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(child: CircularProgressIndicator()),
                              );

                              try {
                                // Delete from local DB
                                await dbService.deleteRecord(recordId);

                                // Refresh local records
                                await recordController.loadRecords();

                                // Try delete from API
                                await apiService.deleteRecord(recordId);

                                // Show success
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Record deleted successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting record: ${error.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                // Always close loading indicator
                                if (Navigator.canPop(context)) {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
//////////////////////////////////////////////
///COMMENTED OUT INITIALLY
  /*@override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final records = Provider.of<RecordController>(context);
    final isFacilitator = auth.currentUser?.role == UserRole.facilitator;

    final facilitators = records.records.map((r) => r.facilitator).toSet().toList();
    final creators = records.records.map((r) => r.createdBy).toSet().toList();

    List<Record> displayRecords = _filterRecords(records.records, auth);

    return Container(
      color: const Color(0xFFF0F0F0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchHeader(
                  title: isFacilitator ? 'Assigned Goods' : 'All Records',
                  searchController: _searchController,
                ),
                // Filter controls
                Container(
                color: Colors.grey.shade50, // Very light grey background
                child: Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        // First row of filters
                        Row(
                          children: [
                            FilterDropdown<String>(
                              label: 'Document Type',
                              value: _selectedDocumentType,
                              items: const [
                                DropdownMenuItem(value: null, child: Text('All Types')),
                                DropdownMenuItem(value: 'Invoice', child: Text('Delivery')),
                                DropdownMenuItem(value: 'Cash Sale', child: Text('Cash Sale')),
                                DropdownMenuItem(value: 'Quotation', child: Text('Quotation')),
                              ],
                              onChanged: (value) => setState(() => _selectedDocumentType = value),
                            ),
                            const SizedBox(width: 8),
                            FilterDropdown<String>(
                              label: 'Facilitator',
                              value: _selectedFacilitator,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Facilitators')),
                                ...facilitators.map((facilitator) => DropdownMenuItem(
                                  value: facilitator,
                                  child: Text(facilitator),
                                )).toList(),
                              ],
                              onChanged: (value) => setState(() => _selectedFacilitator = value),
                            ),
                            const SizedBox(width: 8),
                            FilterDropdown<String>(
                              label: 'Created By',
                              value: _selectedCreatedBy,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Creators')),
                                ...creators.map((creator) => DropdownMenuItem(
                                  value: creator,
                                  child: Text(creator),
                                )).toList(),
                              ],
                              onChanged: (value) => setState(() => _selectedCreatedBy = value),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Date range picker
                        DateRangePicker(
                          fromDate: _fromDate,
                          toDate: _toDate,
                          onDateSelected: _selectDate,
                          onClearDates: () => setState(() {
                            _fromDate = null;
                            _toDate = null;
                          }),
                        ),
                        const SizedBox(height: 12),

                        // Amount range and reset button
                        Row(
                          children: [
                            Expanded(
                              child: AmountRangeFilter(
                                minAmount: _minAmount,
                                maxAmount: _maxAmount,
                                onMinAmountChanged: (value) => setState(() {
                                  _minAmount = double.tryParse(value) ?? 0;
                                }),
                                onMaxAmountChanged: (value) => setState(() {
                                  _maxAmount = double.tryParse(value) ?? 100000;
                                }),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ResetFiltersButton(onPressed: _resetFilters),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 8),

                // Records table
                Flexible(
                  child: RecordsTable(
                    records: displayRecords,
                    isAdmin: auth.currentUser?.role == UserRole.admin,
                    sortAscending: _sortAscending,
                    sortColumnIndex: _sortColumnIndex,
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                      onEditRecord: (record) {
                    // Show a dialog or navigate to a form with the record data
                    _showEditRecordDialog(context, record);},
                    // records_table_view.dart
             onDeleteRecord: (recordId) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Record'),
                content: const Text('Are you sure you want to delete this record?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close confirmation dialog

                      final recordController = Provider.of<RecordController>(context, listen: false);
                      final dbService = DbService.instance;
                      final apiService = ApiService();

                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        // Delete from local DB
                        await dbService.deleteRecord(recordId);

                        // Refresh local records
                        await recordController.loadRecords();

                        // Try delete from API
                        await apiService.deleteRecord(recordId);

                        // Show success
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Record deleted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting record: ${error.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        // Always close loading indicator
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}*///////////////////////////////////////////////////////
//COMENTED OUT INITIALLY//

// Helper widgets
InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFF2A4D8F)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    filled: true,
    fillColor: const Color(0xFFEAF1FF),
  );
}

Widget _buildTextField({
  required String? initialValue,
  required String label,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  required Function(String) onChanged,
}) {
  return TextFormField(
    initialValue: initialValue,
    decoration: _inputDecoration(label),
    keyboardType: keyboardType,
    validator: validator ?? (value) => value?.isEmpty ?? true ? 'Required' : null,
    onChanged: onChanged,
  );
}

void _showEditRecordDialog(BuildContext context, Record record) async {
  final formKey = GlobalKey<FormState>();
  final dbService = DbService.instance;
  final apiService = ApiService();

  String? customerName = record.customerName;
  String? facilitator = record.facilitator;
  double? amount = record.amount;
  String? documentNumber;
  String? documentType;

  // Determine which document type this record has
  if (record.invoiceNo != null) {
    documentType = 'invoice';
    documentNumber = record.invoiceNo;
  } else if (record.cashSaleNo != null) {
    documentType = 'cashSale';
    documentNumber = record.cashSaleNo;
  } else if (record.quotationNo != null) {
    documentType = 'quotation';
    documentNumber = record.quotationNo;
  }

  final result = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFFEDF4FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Edit Record',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A4D8F),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Form
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        initialValue: customerName,
                        label: 'Customer Name',
                        onChanged: (value) => customerName = value,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: facilitator,
                        label: 'Facilitator',
                        onChanged: (value) => facilitator = value,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: amount?.toStringAsFixed(2),
                        label: 'Amount',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Required';
                          if (double.tryParse(value!) == null) return 'Invalid number';
                          return null;
                        },
                        onChanged: (value) => amount = double.tryParse(value),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: documentType,
                        items: const [
                          DropdownMenuItem(value: 'invoice', child: Text('Invoice')),
                          DropdownMenuItem(value: 'cashSale', child: Text('Cash Sale')),
                          DropdownMenuItem(value: 'quotation', child: Text('Quotation')),
                        ],
                        decoration: _inputDecoration('Document Type'),
                        onChanged: (value) => documentType = value,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: documentNumber,
                        label: 'Document Number',
                        onChanged: (value) => documentNumber = value,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final updatedRecord = Record(
                            id: record.id,
                            date: record.date,
                            time: record.time,
                            customerName: customerName!,
                            facilitator: facilitator!,
                            amount: amount!,
                            createdBy: record.createdBy,
                            createdAt: record.createdAt,
                            invoiceNo: documentType == 'invoice' ? documentNumber : null,
                            cashSaleNo: documentType == 'cashSale' ? documentNumber : null,
                            quotationNo: documentType == 'quotation' ? documentNumber : null,
                          );
                          Navigator.pop(context, updatedRecord);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A4D8F),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  if (result != null && result is Record) {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Update in local database first
    await dbService.updateRecord(result);

    // Update in the API
    try {
      await apiService.updateRecord(result);
      await apiService.getRemoteRecords();
    } catch (apiError) {
      // API update failed, show warning
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated locally but failed to sync: ${apiError.toString()}'),
          backgroundColor: Colors.orange,
        ),
      );
    }

    // Hide loading indicator
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Record updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    // Hide loading indicator
    Navigator.of(context).pop();

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to update record: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}}*/



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/user_model.dart';
import '../models/record_model.dart';
import '../components/filter_controls.dart';
import '../components/records_table.dart';
import '../components/search_header.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';

class RecordsTableView extends StatefulWidget {
  const RecordsTableView({super.key});

  @override
  State<RecordsTableView> createState() => _RecordsTableViewState();
}

class _RecordsTableViewState extends State<RecordsTableView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  double _minAmount = 0;
  double _maxAmount = 100000;
  String? _selectedDocumentType;
  String? _selectedFacilitator;
  String? _selectedCreatedBy;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  int _currentPage = 0;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Record> _filterRecords(List<Record> records, AuthController auth) {
    bool isFacilitator = auth.currentUser?.role == UserRole.facilitator;
    
    List<Record> filtered = isFacilitator
        ? records.where((r) => r.facilitator == auth.currentUser!.name).toList()
        : List.from(records);

    if (_searchText.isNotEmpty) {
      filtered = filtered.where((record) {
        return record.customerName.toLowerCase().contains(_searchText) ||
            (record.invoiceNo?.toLowerCase().contains(_searchText) ?? false) ||
            (record.cashSaleNo?.toLowerCase().contains(_searchText) ?? false) ||
            (record.quotationNo?.toLowerCase().contains(_searchText) ?? false) ||
            record.facilitator.toLowerCase().contains(_searchText) ||
            record.createdBy.toLowerCase().contains(_searchText);
      }).toList();
    }

    if (_selectedDocumentType != null) {
      filtered = filtered.where((record) {
        if (_selectedDocumentType == 'Invoice') {
          return record.invoiceNo?.isNotEmpty ?? false;
        } else if (_selectedDocumentType == 'Cash Sale') {
          return record.cashSaleNo?.isNotEmpty ?? false;
        } else if (_selectedDocumentType == 'Quotation') {
          return record.quotationNo?.isNotEmpty ?? false;
        }
        return true;
      }).toList();
    }

    if (_fromDate != null || _toDate != null) {
      filtered = filtered.where((record) {
        final recordDate = record.date;
        bool afterFrom = _fromDate == null || recordDate.isAfter(_fromDate!);
        bool beforeTo = _toDate == null || recordDate.isBefore(_toDate!.add(const Duration(days: 1)));
        return afterFrom && beforeTo;
      }).toList();
    }

    filtered = filtered.where((record) {
      return record.amount >= _minAmount && record.amount <= _maxAmount;
    }).toList();

    if (_selectedFacilitator != null) {
      filtered = filtered.where((record) => record.facilitator == _selectedFacilitator).toList();
    }

    if (_selectedCreatedBy != null) {
      filtered = filtered.where((record) => record.createdBy == _selectedCreatedBy).toList();
    }

    filtered.sort((a, b) {
      int compareResult;
      switch (_sortColumnIndex) {
        case 0: compareResult = a.date.compareTo(b.date); break;
        case 1: compareResult = a.time.compareTo(b.time); break;
        case 2: compareResult = a.customerName.compareTo(b.customerName); break;
        case 3: compareResult = _getRecordType(a).compareTo(_getRecordType(b)); break;
        case 4: compareResult = _getRecordNumber(a).compareTo(_getRecordNumber(b)); break;
        case 5: compareResult = a.facilitator.compareTo(b.facilitator); break;
        case 6: compareResult = a.amount.compareTo(b.amount); break;
        case 7: compareResult = a.createdBy.compareTo(b.createdBy); break;
        default: compareResult = a.date.compareTo(b.date);
      }
      return _sortAscending ? compareResult : -compareResult;
    });

    return filtered;
  }

  String _getRecordType(Record record) {
    if ((record.invoiceNo ?? '').isNotEmpty) return 'Invoice';
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

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate ?? DateTime.now() : _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(picked)) {
            _toDate = null;
          }
        } else {
          _toDate = picked;
          if (_fromDate != null && _fromDate!.isAfter(picked)) {
            _fromDate = null;
          }
        }
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedDocumentType = null;
      _selectedFacilitator = null;
      _selectedCreatedBy = null;
      _fromDate = null;
      _toDate = null;
      _minAmount = 0;
      _maxAmount = 100000;
      _searchController.clear();
    });
  }

  List<Record> _getPaginatedRecords(List<Record> records) {
    final start = _currentPage * _pageSize;
    final end = start + _pageSize;
    return records.sublist(start, end > records.length ? records.length : end);
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) _currentPage--;
    });
  }

  /*@override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final records = Provider.of<RecordController>(context);
    final isFacilitator = auth.currentUser?.role == UserRole.facilitator;

    final facilitators = records.records.map((r) => r.facilitator).toSet().toList();
    final creators = records.records.map((r) => r.createdBy).toSet().toList();

    List<Record> filteredRecords = _filterRecords(records.records, auth);
    List<Record> paginatedRecords = _getPaginatedRecords(filteredRecords);

    return Container(
      color: const Color(0xFFF0F0F0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchHeader(
                  title: isFacilitator ? 'Assigned Goods' : 'All Records',
                  searchController: _searchController,
                ),
                // Filter controls
                Container(
                  color: Colors.grey.shade50, // Very light grey background
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          // First row of filters
                          Row(
                            children: [
                              FilterDropdown<String>(
                                label: 'Document Type',
                                value: _selectedDocumentType,
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('All Types')),
                                  DropdownMenuItem(value: 'Invoice', child: Text('Delivery')),
                                  DropdownMenuItem(value: 'Cash Sale', child: Text('Cash Sale')),
                                  DropdownMenuItem(value: 'Quotation', child: Text('Quotation')),
                                ],
                                onChanged: (value) => setState(() => _selectedDocumentType = value),
                              ),
                              const SizedBox(width: 8),
                              FilterDropdown<String>(
                                label: 'Facilitator',
                                value: _selectedFacilitator,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Facilitators')),
                                  ...facilitators.map((facilitator) => DropdownMenuItem(
                                    value: facilitator,
                                    child: Text(facilitator),
                                  )).toList(),
                                ],
                                onChanged: (value) => setState(() => _selectedFacilitator = value),
                              ),
                              const SizedBox(width: 8),
                              FilterDropdown<String>(
                                label: 'Created By',
                                value: _selectedCreatedBy,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Creators')),
                                  ...creators.map((creator) => DropdownMenuItem(
                                    value: creator,
                                    child: Text(creator),
                                  )).toList(),
                                ],
                                onChanged: (value) => setState(() => _selectedCreatedBy = value),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date range picker
                          DateRangePicker(
                            fromDate: _fromDate,
                            toDate: _toDate,
                            onDateSelected: _selectDate,
                            onClearDates: () => setState(() {
                              _fromDate = null;
                              _toDate = null;
                            }),
                          ),
                          const SizedBox(height: 12),

                          // Amount range and reset button
                          Row(
                            children: [
                              Expanded(
                                child: AmountRangeFilter(
                                  minAmount: _minAmount,
                                  maxAmount: _maxAmount,
                                  onMinAmountChanged: (value) => setState(() {
                                    _minAmount = double.tryParse(value) ?? 0;
                                  }),
                                  onMaxAmountChanged: (value) => setState(() {
                                    _maxAmount = double.tryParse(value) ?? 100000;
                                  }),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ResetFiltersButton(onPressed: _resetFilters),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Records table
                Flexible(
                  child: RecordsTable(
                    records: paginatedRecords,
                    isAdmin: auth.currentUser?.role == UserRole.admin,
                    sortAscending: _sortAscending,
                    sortColumnIndex: _sortColumnIndex,
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                      });
                    },
                    onEditRecord: (record) {
                      _showEditRecordDialog(context, record);
                    },
                    onDeleteRecord: (recordId) {
                      // Handle delete logic here
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      color: Colors.blue.shade700,
                      tooltip: 'Previous Page',
                      onPressed: filteredRecords.isNotEmpty && _currentPage > 0
                          ? _previousPage
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Page ${_currentPage + 1} of ${((filteredRecords.length - 1) / _pageSize).floor() + 1}',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      color: Colors.blue.shade700,
                      tooltip: 'Next Page',
                      onPressed: filteredRecords.isNotEmpty &&
                              (_currentPage + 1) * _pageSize < filteredRecords.length
                          ? _nextPage
                          : null,
                    ),
                  ),
                ],
              ),

              ],
            ),
          );
        },
      ),
    );
  }
}*/
@override
Widget build(BuildContext context) {
  final auth = Provider.of<AuthController>(context);
  final records = Provider.of<RecordController>(context);
  final isFacilitator = auth.currentUser?.role == UserRole.facilitator;
  final isAdmin = auth.currentUser?.role == UserRole.admin;

  final facilitators = records.records.map((r) => r.facilitator).toSet().toList();
  final creators = records.records.map((r) => r.createdBy).toSet().toList();

  List<Record> filteredRecords = _filterRecords(records.records, auth);
  List<Record> paginatedRecords = _getPaginatedRecords(filteredRecords);

  return Container(
    color: const Color(0xFFF0F0F0),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchHeader(
                title: isFacilitator ? 'Assigned Goods' : 'All Records',
                searchController: _searchController,
              ),
              // Filter controls
              if (isAdmin) // Only show filter controls if the user is an admin
                Container(
                  color: Colors.grey.shade50, // Very light grey background
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          // First row of filters
                          Row(
                            children: [
                              FilterDropdown<String>(
                                label: 'Document Type',
                                value: _selectedDocumentType,
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('All Types')),
                                  DropdownMenuItem(value: 'Invoice', child: Text('Delivery')),
                                  DropdownMenuItem(value: 'Cash Sale', child: Text('Cash Sale')),
                                  DropdownMenuItem(value: 'Quotation', child: Text('Quotation')),
                                ],
                                onChanged: (value) => setState(() => _selectedDocumentType = value),
                              ),
                              const SizedBox(width: 8),
                              FilterDropdown<String>(
                                label: 'Facilitator',
                                value: _selectedFacilitator,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Facilitators')),
                                  ...facilitators.map((facilitator) => DropdownMenuItem(
                                    value: facilitator,
                                    child: Text(facilitator),
                                  )).toList(),
                                ],
                                onChanged: (value) => setState(() => _selectedFacilitator = value),
                              ),
                              const SizedBox(width: 8),
                              FilterDropdown<String>(
                                label: 'Created By',
                                value: _selectedCreatedBy,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Creators')),
                                  ...creators.map((creator) => DropdownMenuItem(
                                    value: creator,
                                    child: Text(creator),
                                  )).toList(),
                                ],
                                onChanged: (value) => setState(() => _selectedCreatedBy = value),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date range picker
                          DateRangePicker(
                            fromDate: _fromDate,
                            toDate: _toDate,
                            onDateSelected: _selectDate,
                            onClearDates: () => setState(() {
                              _fromDate = null;
                              _toDate = null;
                            }),
                          ),
                          const SizedBox(height: 12),

                          // Amount range and reset button
                          Row(
                            children: [
                              Expanded(
                                child: AmountRangeFilter(
                                  minAmount: _minAmount,
                                  maxAmount: _maxAmount,
                                  onMinAmountChanged: (value) => setState(() {
                                    _minAmount = double.tryParse(value) ?? 0;
                                  }),
                                  onMaxAmountChanged: (value) => setState(() {
                                    _maxAmount = double.tryParse(value) ?? 100000;
                                  }),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ResetFiltersButton(onPressed: _resetFilters),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              // Records table
              Flexible(
                child: RecordsTable(
                  records: paginatedRecords,
                  isAdmin: isAdmin,
                  sortAscending: _sortAscending,
                  sortColumnIndex: _sortColumnIndex,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                    });
                  },
                  onEditRecord: (record) {
                    _showEditRecordDialog(context, record);
                  },
                  onDeleteRecord: (recordId) {
                    // Handle delete logic here
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      color: Colors.blue.shade700,
                      tooltip: 'Previous Page',
                      onPressed: filteredRecords.isNotEmpty && _currentPage > 0
                          ? _previousPage
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Page ${_currentPage + 1} of ${((filteredRecords.length - 1) / _pageSize).floor() + 1}',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      color: Colors.blue.shade700,
                      tooltip: 'Next Page',
                      onPressed: filteredRecords.isNotEmpty &&
                              (_currentPage + 1) * _pageSize < filteredRecords.length
                          ? _nextPage
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

// Helper widgets
InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFF2A4D8F)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    filled: true,
    fillColor: const Color(0xFFEAF1FF),
  );
}

Widget _buildTextField({
  required String? initialValue,
  required String label,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  required Function(String) onChanged,
}) {
  return TextFormField(
    initialValue: initialValue,
    decoration: _inputDecoration(label),
    keyboardType: keyboardType,
    validator: validator ?? (value) => value?.isEmpty ?? true ? 'Required' : null,
    onChanged: onChanged,
  );
}

void _showEditRecordDialog(BuildContext context, Record record) async {
  final formKey = GlobalKey<FormState>();
  final dbService = DbService.instance;
  final apiService = ApiService();

  String? customerName = record.customerName;
  String? facilitator = record.facilitator;
  double? amount = record.amount;
  String? documentNumber;
  String? documentType;

  // Determine which document type this record has
  if (record.invoiceNo != null) {
    documentType = 'invoice';
    documentNumber = record.invoiceNo;
  } else if (record.cashSaleNo != null) {
    documentType = 'cashSale';
    documentNumber = record.cashSaleNo;
  } else if (record.quotationNo != null) {
    documentType = 'quotation';
    documentNumber = record.quotationNo;
  }

  final result = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFFEDF4FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Edit Record',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A4D8F),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Form
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        initialValue: customerName,
                        label: 'Customer Name',
                        onChanged: (value) => customerName = value,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: facilitator,
                        label: 'Facilitator',
                        onChanged: (value) => facilitator = value,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: amount?.toStringAsFixed(2),
                        label: 'Amount',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Required';
                          if (double.tryParse(value!) == null) return 'Invalid number';
                          return null;
                        },
                        onChanged: (value) => amount = double.tryParse(value),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: documentType,
                        items: const [
                          DropdownMenuItem(value: 'invoice', child: Text('Invoice')),
                          DropdownMenuItem(value: 'cashSale', child: Text('Cash Sale')),
                          DropdownMenuItem(value: 'quotation', child: Text('Quotation')),
                        ],
                        decoration: _inputDecoration('Document Type'),
                        onChanged: (value) => documentType = value,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: documentNumber,
                        label: 'Document Number',
                        onChanged: (value) => documentNumber = value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final updatedRecord = Record(
                            id: record.id,
                            date: record.date,
                            time: record.time,
                            customerName: customerName!,
                            facilitator: facilitator!,
                            amount: amount!,
                            createdBy: record.createdBy,
                            createdAt: record.createdAt,
                            invoiceNo: documentType == 'invoice' ? documentNumber : null,
                            cashSaleNo: documentType == 'cashSale' ? documentNumber : null,
                            quotationNo: documentType == 'quotation' ? documentNumber : null,
                          );
                          Navigator.pop(context, updatedRecord);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A4D8F),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  if (result != null && result is Record) {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Update in local database first
      await dbService.updateRecord(result);

      // Update in the API
      try {
        await apiService.updateRecord(result);
        await apiService.getRemoteRecords();
      } catch (apiError) {
        // API update failed, show warning
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated locally but failed to sync: ${apiError.toString()}'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Hide loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update record: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}}