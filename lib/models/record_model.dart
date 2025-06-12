// models/record_model.dart
/*class Record {
  final String? id;
  final DateTime date;
  final DateTime time;
  final String customerName;
  final String invoiceNo;
  final String cashSaleNo;
  final String quotationNo;
  final String facilitator;
  final double amount;
  final String createdBy;
  final DateTime createdAt;

  Record({
    this.id,
    required this.date,
    required this.time,
    required this.customerName,
    required this.invoiceNo,
    required this.cashSaleNo,
    required this.quotationNo,
    required this.facilitator,
    required this.amount,
    required this.createdBy,
    required this.createdAt,
  });

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      date: DateTime.parse(map['date']),
      time: DateTime.parse(map['time']),
      customerName: map['customerName'],
      invoiceNo: map['invoiceNo'],
      cashSaleNo: map['cashSaleNo'],
      quotationNo: map['quotationNo'],
      facilitator: map['facilitator'],
      amount: map['amount'],
      createdBy: map['createdBy'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'customerName': customerName,
      'invoiceNo': invoiceNo,
      'cashSaleNo': cashSaleNo,
      'quotationNo': quotationNo,
      'facilitator': facilitator,
      'amount': amount,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}*/
///////////////////////////////////////////
/*import 'package:uuid/uuid.dart';

class Record {
  final String id;
  final DateTime date;
  final DateTime time;
  final String customerName;
  final String? invoiceNo; // Make nullable
  final String? cashSaleNo; // Make nullable
  final String? quotationNo; // Make nullable
  final String facilitator;
  final double amount;
  final String createdBy; // Now just a name string
  final DateTime createdAt;

  Record({
    String? id,
    required this.date,
    required this.time,
    required this.customerName,
    this.invoiceNo,
    this.cashSaleNo,
    this.quotationNo,
    required this.facilitator,
    required this.amount,
    required this.createdBy,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4() {
    // Validate that only one document type is provided
    final documentTypes = [
      if (invoiceNo != null && invoiceNo!.isNotEmpty) 1 else 0,
      if (cashSaleNo != null && cashSaleNo!.isNotEmpty) 1 else 0,
      if (quotationNo != null && quotationNo!.isNotEmpty) 1 else 0,
    ].reduce((a, b) => a + b);
    
    if (documentTypes != 1) {
      throw ArgumentError('Exactly one document type must be provided (invoiceNo, cashSaleNo, or quotationNo)');
    }
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      date: DateTime.parse(map['date']),
      time: DateTime.parse(map['time']),
      customerName: map['customerName'],
      invoiceNo: map['invoiceNo'],
      cashSaleNo: map['cashSaleNo'],
      quotationNo: map['quotationNo'],
      facilitator: map['facilitator'],
      amount: (map['amount'] as num).toDouble(),
      createdBy: map['createdBy'] is String ? map['createdBy'] : 'Unknown',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'customerName': customerName,
      'invoiceNo': invoiceNo,
      'cashSaleNo': cashSaleNo,
      'quotationNo': quotationNo,
      'facilitator': facilitator,
      'amount': amount,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}*/
///////////////////////////////////////////
/*class Record {
  final String id;
  final DateTime date;
  final DateTime time;
  final String customerName;
  final String invoiceNo;
  final String cashSaleNo;
  final String quotationNo;
  final String facilitator;
  final double amount;
  final String createdBy;
  final DateTime createdAt;

  Record({
    String? id,
    required this.date,
    required this.time,
    required this.customerName,
    required this.invoiceNo,
    required this.cashSaleNo,
    required this.quotationNo,
    required this.facilitator,
    required this.amount,
    required this.createdBy,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4(); 

  
  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      date: DateTime.parse(map['date']),
      time: DateTime.parse(map['time']),
      customerName: map['customerName'],
      invoiceNo: map['invoiceNo'],
      cashSaleNo: map['cashSaleNo'],
      quotationNo: map['quotationNo'],
      facilitator: map['facilitator'],
      amount: (map['amount'] as num).toDouble(),
      //amount: map['amount'],
      createdBy: map['createdBy'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'customerName': customerName,
      'invoiceNo': invoiceNo,
      'cashSaleNo': cashSaleNo,
      'quotationNo': quotationNo,
      'facilitator': facilitator,
      'amount': amount,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}*/

import 'package:uuid/uuid.dart';

class Record {
  final String id;
  final DateTime date;
  final DateTime time;
  final String customerName;
  final String? invoiceNo;
  final String? cashSaleNo;
  final String? quotationNo;
  final String facilitator;
  final double amount;
  final String createdBy;
  final DateTime createdAt;

  Record({
    String? id,
    required this.date,
    required this.time,
    required this.customerName,
    this.invoiceNo,
    this.cashSaleNo,
    this.quotationNo,
    required this.facilitator,
    required this.amount,
    required this.createdBy,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4() {
    // Validate only one document type is provided and not empty
    final docTypes = [
      (invoiceNo?.trim().isNotEmpty ?? false) ? 1 : 0,
      (cashSaleNo?.trim().isNotEmpty ?? false) ? 1 : 0,
      (quotationNo?.trim().isNotEmpty ?? false) ? 1 : 0,
    ].reduce((a, b) => a + b);

    if (docTypes != 1) {
      throw ArgumentError(
          'Exactly one document type must be provided (invoiceNo, cashSaleNo, or quotationNo)');
    }
  }

factory Record.fromMap(Map<String, dynamic> map) {
  String? clean(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  // Temporary variables to hold document numbers
  final invoiceNo = clean(map['invoiceNo']);
  final cashSaleNo = clean(map['cashSaleNo']);
  final quotationNo = clean(map['quotationNo']);

  // For existing records that might have multiple document types,
  // we'll prioritize invoiceNo > cashSaleNo > quotationNo
  String? finalInvoiceNo;
  String? finalCashSaleNo;
  String? finalQuotationNo;

  if (invoiceNo != null) {
    finalInvoiceNo = invoiceNo;
  } else if (cashSaleNo != null) {
    finalCashSaleNo = cashSaleNo;
  } else if (quotationNo != null) {
    finalQuotationNo = quotationNo;
  }

  return Record(
    id: map['id'] ?? map['_id'],
    date: DateTime.parse(map['date']),
    time: DateTime.parse(map['time']),
    customerName: map['customerName'] ?? '',
    invoiceNo: finalInvoiceNo,
    cashSaleNo: finalCashSaleNo,
    quotationNo: finalQuotationNo,
    facilitator: map['facilitator'] ?? '',
    amount: (map['amount'] as num).toDouble(),
    createdBy: map['createdBy'] ?? 'Unknown',
    createdAt: DateTime.parse(map['createdAt']),
  );
}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'customerName': customerName,
      'invoiceNo': invoiceNo,
      'cashSaleNo': cashSaleNo,
      'quotationNo': quotationNo,
      'facilitator': facilitator,
      'amount': amount,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
