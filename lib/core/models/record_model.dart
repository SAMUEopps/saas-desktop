// models/record_model.dart
class Record {
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
}