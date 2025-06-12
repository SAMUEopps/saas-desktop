// controllers/record_controller.dart
/*import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/db_service.dart';

class RecordController with ChangeNotifier {
  final DbService _db = DbService.instance;
  List<Record> _records = [];
  bool _isLoading = false;

  List<Record> get records => _records;
  bool get isLoading => _isLoading;

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();
    
    _records = await _db.getRecords();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRecord(Record record) async {
    await _db.addRecord(record);
    await loadRecords();
  }

  Future<void> updateRecord(Record record) async {
    await _db.updateRecord(record);
    await loadRecords();
  }

  Future<void> deleteRecord(String id) async {
    await _db.deleteRecord(id);
    await loadRecords();
  }

  List<Record> getRecordsForFacilitator(String facilitatorName) {
    return _records.where((r) => r.facilitator == facilitatorName).toList();
  }
}*/
import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';

class RecordController with ChangeNotifier {
  final DbService _db = DbService.instance;
  final ApiService _api = ApiService();
  List<Record> _records = [];
  bool _isLoading = false;
  bool _isSyncing = false;

  List<Record> get records => _records;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();
    
    _records = await _db.getRecords();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> syncRecords() async {
    if (_isSyncing) return;
    
    _isSyncing = true;
    notifyListeners();
    
    try {
      // Get local records
      final localRecords = await _db.getRecords();
      
      // Sync to remote
      final syncedRecords = await _api.syncRecords(localRecords);
      
      // Update local DB with any changes from server
      for (final record in syncedRecords) {
        await _db.updateRecord(record);
      }
      
      // Reload records
      await loadRecords();
    } catch (e) {
      // Handle error or ignore if offline
      print('Sync failed: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

Future<void> addRecord(Record record) async {
  try {
    // Validate the record before saving
    await _db.addRecord(record);
    print('[AddRecord] Successfully added record locally: ${record.id}');
  } catch (e) {
    print('[AddRecord][Error] Failed to add record locally: $e');
    rethrow; // Re-throw to let the UI handle the error
  }

  try {
    await loadRecords();
    print('[AddRecord] Records reloaded successfully');
  } catch (e) {
    print('[AddRecord][Error] Failed to reload records: $e');
  }

  // Try to sync in background
  try {
    print('[AddRecord] Attempting to sync record to cloud...');
    await syncRecords();
    print('[AddRecord] Sync completed successfully');
  } catch (e) {
    print('[AddRecord][Warning] Sync failed: $e');
    // Don't rethrow sync errors - the record is saved locally
  }
}

  Future<void> updateRecord(Record record) async {
    await _db.updateRecord(record);
    await loadRecords();
    
    // Try to sync in background
    try {
      await syncRecords();
    } catch (e) {
      // Ignore if sync fails
    }
  }

  Future<void> deleteRecord(String id) async {
    await _db.deleteRecord(id);
    await loadRecords();
    
    // Try to sync in background
    try {
      await syncRecords();
    } catch (e) {
      // Ignore if sync fails
    }
  }

  List<Record> getRecordsForFacilitator(String facilitatorName) {
    return _records.where((r) => r.facilitator == facilitatorName).toList();
  }
}