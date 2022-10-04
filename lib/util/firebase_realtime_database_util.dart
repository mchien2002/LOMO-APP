import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBaseRealTimeDatabaseUtil {
  late DatabaseReference db;
  init() async {
    final FirebaseApp app = await Firebase.initializeApp();
    db = FirebaseDatabase(app: app).reference();
    db.child('lomo-1fb0f').once().then((result) {
      print(
          'Connected to directly configured database and read ${result.value}');
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  setData(String key, dynamic value) async {
    await db.push().set({key: value});
  }
}
