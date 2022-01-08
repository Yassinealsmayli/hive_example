import 'package:flutter/material.dart';
import 'package:hive_example/boxs.dart';
import 'package:hive_example/model/note.dart';
import 'package:hive_example/notes_notifier.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class NotePage extends StatefulWidget {
  final int? id;
  const NotePage({this.id, Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Note? note;
  bool isLoading = false;
  bool canSave = false;

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
    getNote();
  }

  Future getNote() async {
    setState(() {
      isLoading = true;
    });
    note = Hive.box<Note>(boxName).get(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    title.text = note!.title;
    description.text = note!.description;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : _notePage();
  }

  Widget _notePage() => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    canSave = true;
                    note!.isImportant = !(note!.isImportant);
                  });
                },
                icon: Icon(
                  Icons.star,
                  color: note!.isImportant ? Colors.yellow : Colors.grey,
                )),
            IconButton(
                onPressed: () {
                        note!.title = title.text;
                        note!.description = description.text;
                        Provider.of<NoteNotifier>(context, listen: false)
                            .update(id: widget.id, note: note);
                        getNote();
                        canSave = false;
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
                  onChanged: (_) {
                    canSave = true;
                  },
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
                SizedBox(
                  height: defaultPadding,
                  child: Text(
                    "${note!.createdTime}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const Text("description:",
                    style: TextStyle(fontSize: defaultPadding)),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                Expanded(
                  child: TextFormField(
                    controller: description,
                    onChanged: (_) {
                      canSave = true;
                    },
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ],
            )),
      );
}
