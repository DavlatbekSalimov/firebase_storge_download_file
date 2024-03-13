import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebbase/pages/notes/notes.dart';
import 'package:firebbase/pages/upload_and%20donowload/document_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const 
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final remoutconfig = FirebaseRemoteConfig.instance;
  bool texnikkorik = false;

  Future<void> fetchactive() async {
    remoutconfig.fetchAndActivate().then((value) {
      texnikkorik = remoutconfig.getBool('feault');
    });
  }

  Future<void> onInit() async {
    remoutconfig.setDefaults({
      'feault': texnikkorik,
    });

    await fetchactive();
    remoutconfig.onConfigUpdated.listen((event) async {
      await fetchactive();
      setState(() {});
    });
    setState(() {});
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: texnikkorik
          ? const Center(
              child: Text('Ittimos ilovada tamirlash ishlari olib borilmoqda'),
            )
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: TabBar(
                    indicatorWeight: 1,
                    indicator: UnderlineTabIndicator(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        width: 5,
                        strokeAlign: 2,
                        color: Color(0xFF090089),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.note_alt),
                        text: 'Notes',
                      ),
                      Tab(
                        icon: Icon(Icons.edit_document),
                        text: 'Document',
                      )
                    ]),
              ),
              body: const TabBarView(children: [
                NotesPage(),
                DocumentPage(),
              ]),
            ),
    );
  }
}
