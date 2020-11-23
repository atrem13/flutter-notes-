import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes/models/api-response.dart';
import 'package:notes/models/note-for-listing.dart';
import 'package:notes/services/notes-services.dart';
import 'package:notes/views/note-delete.dart';
import 'package:notes/views/note-modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.I<NoteService>();
  APIResponse<List<NoteForListing>> _apiResponse;
  bool _isLoading = false;
  // List<NoteForListing> notes = [];
  // final notes = [];

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNotesList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Note'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteModify()));
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }
          return ListView.separated(
              separatorBuilder: (_, __) => Divider(
                    height: 2,
                    color: Colors.greenAccent,
                  ),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => NoteDelete(),
                    );
                    return result;
                  },
                  background: Container(
                    color: Colors.redAccent,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _apiResponse.data[index].noteTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime)}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NoteModify(
                              noteID: _apiResponse.data[index].noteID)));
                    },
                  ),
                );
              },
              itemCount: _apiResponse.data.length);
        },
      ),
    );
  }
}
