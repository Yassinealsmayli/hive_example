import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
@HiveField(0)
bool isImportant = false;
 @HiveField(1)
  String title = '';
 @HiveField(2)
String description = '';
 @HiveField(3)
 DateTime createdTime = DateTime.now();
 
}
