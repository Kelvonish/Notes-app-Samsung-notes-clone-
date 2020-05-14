import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteProvider {
  static Database db;

  static Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'notes.db'),
        version: 1, onCreate: (Database db, int version) async {
      db.execute('''
        create table notes(
          id integer primary key autoincrement,
          title text ,
          content text ,
          created text not null,
          updated text 
        );''');
    });
  }

  static Future getNotes(noteId) async {
    if (db == null) {
      await open();
    }
    return db.query("notes",where: 'id=?', whereArgs: [noteId]);
  }

  static Future insertData(Map<String, dynamic> note) async {
    if (db == null) {
      await open();
    }
    db.insert("notes", note);
  }

  static Future updateData(Map<String, dynamic> note) async {
    if (db == null) {
      await open();
    }
    db.update("notes", note, where: 'id=?', whereArgs: [note['id']]);
  }

  static Future deleteNote(noteId) async {
    if (db == null) {
      await open();
    }
    db.delete("notes", where: 'id=?', whereArgs: [noteId]);
  }

  static Future getDetails() async {
    if (db == null) {
      await open();
    }
    return db.query("notes");
  }
}
