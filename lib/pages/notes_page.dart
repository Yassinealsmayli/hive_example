// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hive_example/notes_notifier.dart';
import 'package:hive_example/pages/new_note_page.dart';
import 'package:hive_example/pages/note_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_example/model/note.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isLoading = false;
  int navigatorIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes by yassine Alsmayli"),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddNote(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body:
          isLoading ? const Center(child: CircularProgressIndicator()) : body(),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              navigatorIndex = value;
            });
          },
          currentIndex: navigatorIndex,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:const TextStyle(color: Colors.black54),
          showUnselectedLabels: true,
          unselectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.notes,color:Theme.of(context).primaryColor), label: "Notes"),
            BottomNavigationBarItem(icon: Icon(Icons.star,color:Theme.of(context).primaryColor), label: "favorites",),
          ]),
    );
  }

  Widget body() {
    switch (navigatorIndex) {
      case 0:
        return notesListView();
      case 1:
        return favoriteList();
      default:
        return notesListView();
    }
  }

  Widget notesListView() => SingleChildScrollView(
        child: Wrap(
          children: Provider.of<NoteNotifier>(context).notesList,
        ),
      );

  Widget favoriteList() => SingleChildScrollView(
        child: Wrap(
          spacing: 20,
          children: Provider.of<NoteNotifier>(context)
              .notesList
              .where((e) => e.note.isImportant)
              .toList(),
        ),
      );
}

class NoteTile extends StatelessWidget {
  final Note note;
  final dynamic id;
  NoteTile({
    Key? key,
    required this.note,
    required this.id,
  }) : super(key: key);

  Color tileColor = const Color(0xff457b9d);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 150,
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [tileColor.withOpacity(0.5), tileColor])),
        child: Center(
          child: Text(note.title),
        ),
      ),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("Are'you sure you want to delete this note?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async{
                    await Provider.of<NoteNotifier>(context,listen: false).delete(id);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        );
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotePage(id: id),
        ));
      },
    );
  }
}
