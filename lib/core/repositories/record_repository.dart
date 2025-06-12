// record_repository.dart
import '../../models/user_model.dart';

abstract class RecordRepository {
  Future<List<Record>> getRecords();
  Future<List<Record>> getRecordsForFacilitator(String facilitatorName);
  Future<void> addRecord(Record record);
  Future<void> updateRecord(Record record);
  Future<void> deleteRecord(String id);
  Future<List<User>> getFacilitators();
}