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

  Future<void> createUser(String uid, CvData? data) async {
    if (data == null) return;
    if (data.nameOfCv.isEmpty) {
      data.nameOfCv = "Cv uploaded ${DateTime.now()}";
    }
    DocumentReference doc = FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection("cv_data")
        .doc(data.nameOfCv);
    await doc.set(data.toJson());
  }

  Future<void> removeCv(String uid, String nameOfCv) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection("cv_data")
        .doc(nameOfCv);
    await doc.delete();
  }

  Future<CvData> findWithName(String uid, String nameOfCv) async {
    if (nameOfCv.isEmpty) return CvData.empty();
    var snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection("cv_data")
        .doc(nameOfCv)
        .get();
    if (!snapshot.exists) return CvData.empty();
    var data = snapshot.data();
    if (data == null) {
      return CvData.empty();
    } else {
      return CvData.fromJson(data);
    }
  }
}
