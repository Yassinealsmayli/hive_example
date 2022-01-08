import 'package:flutter/material.dart';
import 'package:hive_example/boxs.dart';
import 'package:hive_example/notes_notifier.dart';
import 'package:hive_example/pages/notes_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'model/note.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>(boxName);

  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
            create: (BuildContext context) {
              return NoteNotifier();
            },
            builder: (context, child) => child!,

            child:const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'notes with hive',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const NotesPage(),
      );
}
