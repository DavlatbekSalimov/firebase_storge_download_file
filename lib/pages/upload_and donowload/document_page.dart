import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebbase/service/storge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  FirebaseRemoteConfig remoutConfig = FirebaseRemoteConfig.instance;

  String backgroundcolor = 'red';

  Map<String, dynamic> colors = {
    "green": const Color(0xFF8db150),
    "yellow": const Color(0xFFBCA76A),
    "red": const Color(0xFFAE3D3B),
    "teal": const Color(0xFFCDAE3B),
    "blue": const Color.fromARGB(255, 110, 178, 234),
  };

  Future<void> onInit() async {
    remoutConfig.setDefaults({
      'background': backgroundcolor,
    });
    await fetchAvtiv();
    remoutConfig.onConfigUpdated.listen((event) async {
      await fetchAvtiv();
    });
    setState(() {});
  }

  Future<void> fetchAvtiv() async {
    remoutConfig.fetchAndActivate().then((value) {
      backgroundcolor = remoutConfig.getString('background');
    });
  }

  static Future<File> getFile() async {
    File file = File("");

    FilePickerResult? pickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      "zip",
      "mp3",
      "jpg",
      'mp3',
      'm4a',
    ]);
    if (pickerResult != null) {
      file = File(pickerResult.files.single.path!);
    }
    return file;
  }

  Future<void> uploadFile() async {
    FBStorge.upload(file: await getFile());
  }

  List<String> filesname = [];
  List<String> filessurl = [];

  Future<void> upFileName() async {
    filesname = await FBStorge.uploadFileName();
    filessurl = await FBStorge.uploadFileURL();
    setState(() {});
  }

  @override
  void initState() {
    upFileName();
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[backgroundcolor],
      body: RefreshIndicator(
          child: GridView.builder(
              itemCount: filesname.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.5,
                crossAxisCount: 2,
                // mainAxisSpacing: 720 / 100,
                // crossAxisSpacing: 800 / 3,
              ),
              itemBuilder: (context, index) {
                String fileType =
                    filesname[index].substring(filesname[index].length - 3);
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('Delete the file'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FBStorge.dataUpload(
                                        fileurl: filessurl[index]);
                                    await upFileName();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                )
                              ],
                            );
                          });
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                        color: fileType == 'mp3'
                            ? const Color(0xFF8200ff)
                            : fileType == 'jpg'
                                ? const Color(0xFF9955bb)
                                : fileType == 'mp4'
                                    ? Colors.indigoAccent
                                    : Colors.cyanAccent,
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              fileType == 'mp3'
                                  ? Icons.audio_file_outlined
                                  : fileType == 'jpg'
                                      ? Icons.image_rounded
                                      : fileType == 'mp4'
                                          ? Icons.video_file
                                          : Icons.multitrack_audio_rounded,
                              size: 40,
                            ),
                            Text(
                              fileType,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
          onRefresh: () async {
            upFileName();
            onInit();

            setState(() {});
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await uploadFile();
          setState(() {});
          await upFileName();
          setState(() {});
        },
        child: const Icon(Icons.upload),
      ),
    );
  }
}
