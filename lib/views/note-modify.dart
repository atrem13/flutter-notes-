import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes/models/note-detail.dart';
import 'package:notes/services/notes-services.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;
  NoteService get service => GetIt.I<NoteService>();

  String errorMessage;
  NoteDetail note;
  bool _isLoading = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    service.getNoteDetail(widget.noteID).then((data) {
      print(data);
      setState(() {
        _isLoading = false;
      });
      if (data.error) {
        errorMessage = data.errorMessage ?? 'Terjadi Kesalahan';
      }
      note = data.data;
      _titleController.text = note.noteTitle;
      _contentController.text = note.noteContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Create Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Note Title'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Note Content'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
