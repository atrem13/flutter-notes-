import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes/services/notes-services.dart';
import 'package:notes/views/note-list.dart';

void noteSetupLocator() {
  GetIt.I.registerLazySingleton(() => NoteService());
}

void main() {
  noteSetupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
