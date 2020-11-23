import 'package:notes/models/api-response.dart';
import 'package:notes/models/note-detail.dart';
import '../models/note-for-listing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteService {
  static const API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app/';
  static const headers = {'apiKey': 'ce34fc42-e6f1-493e-b60e-0b54d852905f'};
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
}
