import 'package:hive_flutter/hive_flutter.dart';

import 'model/note.dart';

class Boxes {
  static Box<Note> getNotes() => Hive.box<Note>(boxName);
}

const String boxName = 'notes';
