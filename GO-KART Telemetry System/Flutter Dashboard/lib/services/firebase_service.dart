import 'package:firebase_database/firebase_database.dart';

class FirebaseService {

  final DatabaseReference telemetryRef =
      FirebaseDatabase.instance.ref(
        "FormulaKart/Live/Kart01/telemetry",
      );

}