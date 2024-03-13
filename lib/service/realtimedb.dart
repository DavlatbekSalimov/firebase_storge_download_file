import 'package:firebase_database/firebase_database.dart';

class FCServes {
  //? instance
  static final DatabaseReference ref = FirebaseDatabase.instance.ref();
  //? parent path
  static const String parentPath = 'Note';
  //? created
  static Future<void> createNotes({required Map<String, dynamic> data}) async {
    String? childpath = ref.child(parentPath).push().key;
    await ref.child(parentPath).child(childpath!).set(data);
  }

  static Future<List<DataSnapshot>> getNotes() async {
    List<DataSnapshot> list = [];

    DatabaseReference parentp = ref.child(parentPath);
// ignore: unused_local_variable
    DatabaseEvent event = await parentp.once();

    Iterable<DataSnapshot> itareblelist = event.snapshot.children;
    for (var e in itareblelist) {
      list.add(e);
    }
    return list;
  }

//! Dalete
  static Future<void> daleteNotes({required String id}) async {
    await ref.child(parentPath).child(id).remove();
  }

//? Update
  static Future<void> updataNotes(
      {required String id, required Map<String, dynamic> data}) async {
    await ref.child(parentPath).child(id).update(data);
  }
}
