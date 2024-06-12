import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import '../utils/date_utils.dart';

class CourtOrderService {
  final Logger _logger = Logger();

  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('CourtOrder');

  Future<bool> save({
    required String uuid,
    required String email,
    required bool pictureSent,
  }) async {
    try {
      await _databaseReference.child(uuid).set({
        'email': email,
        'picture_sent': pictureSent,
        'order_date': StandardDateUtils.getCurrentDate(),
      });
      _logger.i('Court order inserted successfully for $email');
      return true;
    } catch (error) {
      _logger.e('Failed to insert court order: $error');
      return false;
    }
  }

  Future<bool?> findByUuid(String uuid) async {
    _logger.i(">> Calling findByUuid");
    try {
      DatabaseEvent event = await _databaseReference.child(uuid).once();

      DataSnapshot snapshot = event.snapshot;

      _logger.i(snapshot.value);

      if (snapshot.value != null) {
        Map<Object?, Object?> data = snapshot.value as Map<Object?, Object?>;
        _logger.i(mapToString(data));
        return true;
      } else {
        return false;
      }
    } catch (error) {
      _logger.e('Failed to read court order: $error');
      return false;
    }
  }

  String mapToString(Map<Object?, Object?> map) {
    String result = '';
    map.forEach((key, value) {
      result += '\n >> $value .';
    });
    return result;
  }
}
