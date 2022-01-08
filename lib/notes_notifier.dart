import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_example/pages/notes_page.dart';

import 'boxs.dart';
import 'model/note.dart';

class NoteNotifier extends ChangeNotifier {
  List<NoteTile> notesList = Boxes.getNotes()
      .toMap()
      .entries
      .map((e) => NoteTile(note: e.value, id: e.key))
      .toList();

  Future<int> create(Note note) async {
    int id = await Hive.box<Note>(boxName).add(note);
    notesList.add(NoteTile(note: note, id: id));
    notifyListeners();
    return id;
  }

  update({id, note}) {
    Hive.box<Note>(boxName).put(id, note!);
    notesList.where((e) => e.id == id).toList()[0]=NoteTile(id: id,note: note,);
    notifyListeners();
  }

  delete(id) async {
    await Hive.box<Note>(boxName).delete(id);
    notesList.remove(notesList.where((element) => element.id==id).first);
    notifyListeners();
  }
}
