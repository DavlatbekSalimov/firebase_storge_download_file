import 'package:firebase_database/firebase_database.dart';
import 'package:firebbase/model/notes_model.dart';
import 'package:firebbase/service/realtimedb.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<DataSnapshot> noteslist = [];
  Future<void> getnotes() async {
    noteslist = await FCServes.getNotes();
    setState(() {});
  }

  @override
  void initState() {
    getnotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          child: GridView.builder(
            itemCount: noteslist.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (_, index) {
              // ignore: unused_local_variable
              var item = (noteslist[index].value as Map);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              color: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title'],
                                ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {
                                        // ignore: unused_local_variable
                                        final updatenotestitleCtr =
                                            TextEditingController(
                                          text: item['title'],
                                        );
                                        // ignore: unused_local_variable
                                        final updatenotesdiscriptionCtr =
                                            TextEditingController(
                                                text: item['description']);
                                        showModalBottomSheet(
                                            backgroundColor:
                                                const Color(0xFF118df0),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(120),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    child: TextField(
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Updetetitle',
                                                      ),
                                                      controller:
                                                          updatenotestitleCtr,
                                                    ),
                                                  ),
                                                  TextField(
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'direction',
                                                    ),
                                                    controller:
                                                        updatenotesdiscriptionCtr,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                      ),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          Notes notes = Notes(
                                                            title:
                                                                updatenotestitleCtr
                                                                    .text,
                                                            description:
                                                                updatenotesdiscriptionCtr
                                                                    .text,
                                                            datetime:
                                                                DateTime.now()
                                                                    .toString(),
                                                          );
                                                          //? ma'lumot kreat qilindi
                                                          await FCServes
                                                              .updataNotes(
                                                            id: noteslist[index]
                                                                .key
                                                                .toString(),
                                                            data:
                                                                notes.toJson(),
                                                          );
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                          await getnotes();
                                                        },
                                                        child:
                                                            const Text('Save'),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text('Update'),
                                    ),
                                    PopupMenuItem(
                                      onTap: () async {
                                        FCServes.daleteNotes(
                                          id: noteslist[index].key.toString(),
                                        );
                                        await getnotes();
                                      },
                                      child: const Text('Dalete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Text(item['description']),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item['datetime'].toString().replaceRange(
                                    item['datetime'].toString().length - 7,
                                    26,
                                    '',
                                  ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          onRefresh: () async {
            await getnotes();
            setState(() {});
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(150),
                ),
              ),
              context: context,
              builder: (contex) {
                return MyshowModalBSH(
                  getnotes: getnotes(),
                );
              });
        },
        child: const Icon(
          Icons.arrow_drop_down,
          size: 38,
        ),
      ),
    );
  }
}

class MyshowModalBSH extends StatefulWidget {
  final Future<void> getnotes;
  const MyshowModalBSH({
    super.key,
    required this.getnotes,
  });

  @override
  State<MyshowModalBSH> createState() => _MyshowModalBSHState();
}

class _MyshowModalBSHState extends State<MyshowModalBSH> {
  final titleCtr = TextEditingController();

  final discriptionCtr = TextEditingController();
  @override
  void initState() {
    widget.getnotes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.919,
          child: TextField(
            controller: titleCtr,
            decoration: const InputDecoration(
              hintText: 'Notes Type',
            ),
          ),
        ),
        TextField(
          maxLines: 18,
          controller: discriptionCtr,
          decoration: const InputDecoration(
            hintText: 'discrimination Type',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Notes notes = Notes(
                    title: titleCtr.text,
                    description: discriptionCtr.text,
                    datetime: DateTime.now().toString(),
                  );
                  //? ma'lumot kreat qilindi
                  await FCServes.createNotes(
                    data: notes.toJson(),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  setState(() {});
                  await widget.getnotes;
                },
                child: const Text('Save'),
              )
            ],
          ),
        )
      ],
    );
  }
}
