/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/record_model.dart';
import '../models/user_model.dart';

enum RecordType { invoice, cashSale, quotation }

class RecordFormView extends StatefulWidget {
  const RecordFormView({super.key});

  @override
  State<RecordFormView> createState() => _RecordFormViewState();
}

class _RecordFormViewState extends State<RecordFormView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _invoiceNoController = TextEditingController();
  final _cashSaleNoController = TextEditingController();
  final _quotationNoController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  double _amount = 0.0;
  String? _selectedFacilitator;
  List<User> _facilitators = [];
  RecordType _selectedRecordType = RecordType.invoice;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _loadFacilitators();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _customerNameController.dispose();
    _invoiceNoController.dispose();
    _cashSaleNoController.dispose();
    _quotationNoController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadFacilitators() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final users = await auth.getAllUsers();
    
    setState(() {
      _facilitators = users.where((user) => 
        user.role == UserRole.facilitator).toList();
      
      // Set default selection if facilitators exist
      if (_facilitators.isNotEmpty) {
        _selectedFacilitator = _facilitators.first.name;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFacilitator == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a facilitator')),
        );
        return;
      }

      final record = Record(
        date: _selectedDate,
        time: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        customerName: _customerNameController.text,
        invoiceNo: _selectedRecordType == RecordType.invoice ? _invoiceNoController.text : '',
        cashSaleNo: _selectedRecordType == RecordType.cashSale ? _cashSaleNoController.text : '',
        quotationNo: _selectedRecordType == RecordType.quotation ? _quotationNoController.text : '',
        facilitator: _selectedFacilitator!,
        amount: _amount,
        createdBy: Provider.of<AuthController>(context, listen: false)
            .currentUser!
            .name,
        createdAt: DateTime.now(),
      );

      Provider.of<RecordController>(context, listen: false)
          .addRecord(record)
          .then((_) => Navigator.of(context).pop());
    }
  }

  void _cancelForm() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400), // Limit the width
            child: Card(
              elevation: 4,
              color: const Color(0xFFF7F7F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.inventory_rounded,
                              size: 48,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Add New Record',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                  fontSize: 28,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fill in the details below',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Record Type Selection
                      Column(
                        children: [
                          const Text('Select Record Type'),
                          ListTile(
                            title: const Text('Invoice'),
                            leading: Radio<RecordType>(
                              value: RecordType.invoice,
                              groupValue: _selectedRecordType,
                              onChanged: (RecordType? value) {
                                setState(() {
                                  _selectedRecordType = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Cash Sale'),
                            leading: Radio<RecordType>(
                              value: RecordType.cashSale,
                              groupValue: _selectedRecordType,
                              onChanged: (RecordType? value) {
                                setState(() {
                                  _selectedRecordType = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Quotation'),
                            leading: Radio<RecordType>(
                              value: RecordType.quotation,
                              groupValue: _selectedRecordType,
                              onChanged: (RecordType? value) {
                                setState(() {
                                  _selectedRecordType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Record Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Customer Name Field
                            TextFormField(
                              controller: _customerNameController,
                              decoration: InputDecoration(
                                labelText: 'Customer Name',
                                prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter customer name';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Invoice No. Field
                            if (_selectedRecordType == RecordType.invoice)
                              TextFormField(
                                controller: _invoiceNoController,
                                decoration: InputDecoration(
                                  labelText: 'Invoice No.',
                                  prefixIcon: Icon(Icons.receipt_long_outlined, color: Colors.blue.shade400),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter invoice number';
                                  }
                                  return null;
                                },
                              ),
                            
                            // Cash Sale No. Field
                            if (_selectedRecordType == RecordType.cashSale)
                              TextFormField(
                                controller: _cashSaleNoController,
                                decoration: InputDecoration(
                                  labelText: 'Cash Sale No.',
                                  prefixIcon: Icon(Icons.receipt_long_outlined, color: Colors.blue.shade400),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter cash sale number';
                                  }
                                  return null;
                                },
                              ),
                            
                            // Quotation No. Field
                            if (_selectedRecordType == RecordType.quotation)
                              TextFormField(
                                controller: _quotationNoController,
                                decoration: InputDecoration(
                                  labelText: 'Quotation No.',
                                  prefixIcon: Icon(Icons.receipt_long_outlined, color: Colors.blue.shade400),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter quotation number';
                                  }
                                  return null;
                                },
                              ),
                            
                            const SizedBox(height: 20),
                            
                            // Facilitator Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedFacilitator,
                              decoration: InputDecoration(
                                labelText: 'Facilitator',
                                prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                              items: _facilitators.map((facilitator) {
                                return DropdownMenuItem<String>(
                                  value: facilitator.name,
                                  child: Text(facilitator.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFacilitator = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a facilitator';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Amount Field
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                prefixText: '\Ksh',
                                prefixIcon: Icon(Icons.attach_money_outlined, color: Colors.blue.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _amount = double.tryParse(value) ?? 0.0;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Date and Time Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _selectDate(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.blue.shade400, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Date: ${DateFormat.yMd().format(_selectedDate)}',
                                      style: TextStyle(color: Colors.blue.shade400),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _selectTime(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.blue.shade400, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Time: ${_selectedTime.format(context)}',
                                      style: TextStyle(color: Colors.blue.shade400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Save and Cancel Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text(
                                      'SAVE',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _cancelForm,
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.blue.shade400, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colors.blue.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/record_controller.dart';
import '../models/record_model.dart';
import '../models/user_model.dart';

enum RecordType { invoice, cashSale, quotation }

class RecordFormView extends StatefulWidget {
  const RecordFormView({super.key});

  @override
  State<RecordFormView> createState() => _RecordFormViewState();
}

class _RecordFormViewState extends State<RecordFormView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _invoiceNoController = TextEditingController();
  final _cashSaleNoController = TextEditingController();
  final _quotationNoController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  double _amount = 0.0;
  String? _selectedFacilitator;
  String? _selectedStoreManager;
  List<User> _facilitators = [];
  List<User> _storeManagers = [];
  RecordType _selectedRecordType = RecordType.invoice;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _loadFacilitators();
    _loadStoreManagers();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _customerNameController.dispose();
    _invoiceNoController.dispose();
    _cashSaleNoController.dispose();
    _quotationNoController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadFacilitators() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final users = await auth.getAllUsers();
    
    setState(() {
      _facilitators = users.where((user) => user.role == UserRole.facilitator).toList();
      
      // Set default selection if facilitators exist
      if (_facilitators.isNotEmpty) {
        _selectedFacilitator = _facilitators.first.name;
      }
    });
  }

  Future<void> _loadStoreManagers() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final users = await auth.getAllUsers();
    
    setState(() {
      _storeManagers = users.where((user) => user.role == UserRole.storeManager).toList();
      
      // Set default selection if store managers exist
      if (_storeManagers.isNotEmpty) {
        _selectedStoreManager = _storeManagers.first.name;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFacilitator == null || _selectedStoreManager == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a facilitator and store manager')),
        );
        return;
      }

      final record = Record(
        date: _selectedDate,
        time: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        customerName: _customerNameController.text,
        invoiceNo: _selectedRecordType == RecordType.invoice ? _invoiceNoController.text : '',
        cashSaleNo: _selectedRecordType == RecordType.cashSale ? _cashSaleNoController.text : '',
        quotationNo: _selectedRecordType == RecordType.quotation ? _quotationNoController.text : '',
        facilitator: _selectedFacilitator!,
        amount: _amount,
        createdBy: _selectedStoreManager!,
        createdAt: DateTime.now(),
      );

      Provider.of<RecordController>(context, listen: false)
          .addRecord(record)
          .then((_) => Navigator.of(context).pop());
    }
  }

  void _cancelForm() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400), // Limit the width
            child: Card(
              elevation: 4,
              color: const Color(0xFFF7F7F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.inventory_rounded,
                              size: 48,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Add New Record',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                  fontSize: 28,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fill in the details below',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Record Type Selection
                      Column(
                        children: [
                          const Text('Select Record Type'),
                          ListTile(
                            title: const Text('Invoice'),
                            leading: Radio<RecordType>(
                              value: RecordType.invoice,
                              groupValue: _selectedRecordType,
                              onChanged: (RecordType? value) {
                                setState(() {
                                  _selectedRecordType = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Cash Sale'),
                            leading: Radio<RecordType>(
                              value: RecordType.cashSale,
                              groupValue: _selectedRecordType,
                              onChanged: (RecordType? value) {
                                setState(() {
                                  _selectedRecordType = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Quotation'),
                            leading: Radio<RecordType>(
                              value: RecordType.quotation,
                              groupValue: _selectedRecordType,
                              onChanged: (RecordType? value) {
                                setState(() {
                                  _selectedRecordType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Record Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Customer Name Field
                            TextFormField(
                              controller: _customerNameController,
                              decoration: InputDecoration(
                                labelText: 'Customer Name',
                                prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter customer name';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Invoice No. Field
                            if (_selectedRecordType == RecordType.invoice)
                              TextFormField(
                                controller: _invoiceNoController,
                                decoration: InputDecoration(
                                  labelText: 'Invoice No.',
                                  prefixIcon: Icon(Icons.receipt_long_outlined, color: Colors.blue.shade400),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter invoice number';
                                  }
                                  return null;
                                },
                              ),
                            
                            // Cash Sale No. Field
                            if (_selectedRecordType == RecordType.cashSale)
                              TextFormField(
                                controller: _cashSaleNoController,
                                decoration: InputDecoration(
                                  labelText: 'Cash Sale No.',
                                  prefixIcon: Icon(Icons.receipt_long_outlined, color: Colors.blue.shade400),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter cash sale number';
                                  }
                                  return null;
                                },
                              ),
                            
                            // Quotation No. Field
                            if (_selectedRecordType == RecordType.quotation)
                              TextFormField(
                                controller: _quotationNoController,
                                decoration: InputDecoration(
                                  labelText: 'Quotation No.',
                                  prefixIcon: Icon(Icons.receipt_long_outlined, color: Colors.blue.shade400),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter quotation number';
                                  }
                                  return null;
                                },
                              ),
                            
                            const SizedBox(height: 20),
                            
                            // Facilitator Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedFacilitator,
                              decoration: InputDecoration(
                                labelText: 'Facilitator',
                                prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                              items: _facilitators.map((facilitator) {
                                return DropdownMenuItem<String>(
                                  value: facilitator.name,
                                  child: Text(facilitator.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFacilitator = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a facilitator';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Store Manager Dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedStoreManager,
                              decoration: InputDecoration(
                                labelText: 'Store Manager',
                                prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                              items: _storeManagers.map((manager) {
                                return DropdownMenuItem<String>(
                                  value: manager.name,
                                  child: Text(manager.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStoreManager = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a store manager';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Amount Field
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                prefixText: '\Ksh',
                                prefixIcon: Icon(Icons.attach_money_outlined, color: Colors.blue.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _amount = double.tryParse(value) ?? 0.0;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Date and Time Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _selectDate(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.blue.shade400, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Date: ${DateFormat.yMd().format(_selectedDate)}',
                                      style: TextStyle(color: Colors.blue.shade400),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _selectTime(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.blue.shade400, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Time: ${_selectedTime.format(context)}',
                                      style: TextStyle(color: Colors.blue.shade400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Save and Cancel Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text(
                                      'SAVE',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _cancelForm,
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.blue.shade400, width: 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colors.blue.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}