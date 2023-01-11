import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lrgtool/linkedin_data_structs.dart';

class DatabaseHandler {
  Future<List<CvData>> readCV(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('cv_data')
        .get();

    return snapshot.docs.map((e) => CvData.fromJson(e.data())).toList();
  }

  Future<void> createUser(String uid, CvData data) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection("cv_data")
        .doc(data.timeOfCreation.toString());
    await doc.set(data.toJson());
  }
}
