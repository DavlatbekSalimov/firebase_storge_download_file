import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FBStorge {
  static final storge = FirebaseStorage.instance;
  //?
  // ignore: prefer_const_declarations
  static final parentPath = 'User';
  //? create image
  static Future<String> upload({
    required File file,
  }) async {
    final filepath = storge
        .ref(parentPath)
        .child('${DateTime.now().toString()} ${file.path.substring(
          file.path.lastIndexOf('.'),
        )}');

    // ignore: unused_local_variable
    UploadTask createfile = filepath.putFile(file);

    await createfile.whenComplete(() {});
    return filepath.getDownloadURL();
  }

  static Future uploadFileName() async {
    List<String> list = [];
    // ignore: unused_local_variable
    ListResult files = await storge.ref(parentPath).listAll();

    for (var e in files.items) {
      list.add(e.name);
    }
    return list;
  }

  static Future uploadFileURL() async {
    List<String> list = [];
    // ignore: unused_local_variable
    ListResult files = await storge.ref(parentPath).listAll();

    for (var e in files.items) {
      list.add(await e.getDownloadURL());
    }
    return list;
  }

  static Future<void> dataUpload({required String fileurl}) async {
    // ignore: unused_local_variable
    Reference filename = storge.refFromURL(fileurl);
    await filename.delete();
  }
}
