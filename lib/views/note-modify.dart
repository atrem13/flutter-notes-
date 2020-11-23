import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes/models/note-detail.dart';
import 'package:notes/models/note-manipulation.dart';
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

  insertNewData() async {
    setState(() {
      _isLoading = true;
    });

    final note = NoteManipulation(
      noteTitle: _titleController.text,
      noteContent: _contentController.text,
    );

    final result = await service.createNote(note);

    setState(() {
      _isLoading = false;
    });

    final title = (result.data) ? 'Success' : 'Failed';
    final text =
        (result.error) ? 'Terjadi Kesalahan' : 'Data Berhasil Ditambahkan';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(text),
              actions: [
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            )).then((data) {
      if (result.data) {
        Navigator.of(context).pop();
      }
    });
  }

  updateData() async {
    setState(() {
      _isLoading = true;
    });

    final note = NoteManipulation(
      noteTitle: _titleController.text,
      noteContent: _contentController.text,
    );

    final result = await service.updateNote(widget.noteID, note);

    setState(() {
      _isLoading = false;
    });

    final title = (result.data) ? 'Success' : 'Failed';
    final text =
        (result.error) ? 'Terjadi Kesalahan' : 'Data Berhasil Diperbaharui';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(text),
              actions: [
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            )).then((data) {
      if (result.data) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (isEditing) {
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
                      onPressed: () async {
                        updateData();
                        // Navigator.of(context).pop();
                        if (isEditing) {
                        } else {
                          insertNewData();
                        }
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
