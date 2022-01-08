import 'package:flutter/material.dart';
import 'package:hive_example/model/note.dart';
import 'package:hive_example/notes_notifier.dart';
import 'package:hive_example/pages/note_view.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  Note note = Note();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _notePage();
  }

  Widget _notePage() => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    note.isImportant = !note.isImportant;
                  });
                },
                icon: Icon(
                  Icons.star,
                  color: note.isImportant ? Colors.yellow : Colors.grey,
                )),
            IconButton(
                onPressed: () async {
                  note.title = title.text;
                  note.description = description.text;
                  note.createdTime = DateTime.now();
                  int id =
                      await Provider.of<NoteNotifier>(context, listen: false)
                          .create(note);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => NotePage(id: id),
                  ));
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                const Text("title:",
                    style: TextStyle(fontSize: defaultPadding)),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                TextFormField(
                  controller: title,
                  maxLines: 1,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Text("description:",
                    style: TextStyle(fontSize: defaultPadding)),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Expanded(
                  child: TextFormField(
                    controller: description,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ],
            )),
      );
}
