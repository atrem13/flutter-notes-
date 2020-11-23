import 'package:notes/models/api-response.dart';
import 'package:notes/models/note-detail.dart';
import 'package:notes/models/note-manipulation.dart';
import '../models/note-for-listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteService {
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app/';
  static const headers = {
    'apiKey': 'ce34fc42-e6f1-493e-b60e-0b54d852905f',
    'Content-Type': 'application/json'
  };
  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    return http.get(API + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        print(data);

        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'Terjadi kesalahan');
    }).catchError((_) {
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'Terjadi kesalahan');
    });
  }

  Future<APIResponse<NoteDetail>> getNoteDetail(String noteID) {
    return http.get(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        print(data);

        final jsonData = json.decode(data.body);
        return APIResponse<NoteDetail>(data: NoteDetail.fromJson(jsonData));
      }
      return APIResponse<NoteDetail>(
          error: true, errorMessage: 'Terjadi kesalahan');
    }).catchError((_) {
      return APIResponse<NoteDetail>(
          error: true, errorMessage: 'Terjadi kesalahan');
    });
  }

  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http
        .post(API + 'notes', headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'terjadi kesalahan');
    }).catchError((_) {
      return APIResponse<bool>(error: true, errorMessage: 'terjadi kesalahan');
    });
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteManipulation item) {
    return http
        .put(API + '/notes/' + noteID,
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Terjadi Kesalahan');
    }).catchError((_) {
      return APIResponse<bool>(error: true, errorMessage: 'Terjadi Kesalahan');
    });
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http.delete(API + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Terjadi Kesalahan');
    }).catchError((_) {
      return APIResponse<bool>(error: true, errorMessage: 'Terjadi Kesalahan');
    });
  }
}
