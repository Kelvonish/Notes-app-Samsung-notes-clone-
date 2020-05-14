import 'package:flutter/material.dart';
import 'package:notes/data.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String titleController;
  final _formkey = GlobalKey<FormState>();
  String notesController;
  static var now = DateTime.now();
  static String currentTime = DateFormat("dd-MM-yyyy hh:mm").format(now);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.save,
                color: Colors.white,
                ),
                  onPressed: () {
                     if(_formkey.currentState.validate()){
                    setState(() { 
                      NoteProvider.insertData({
                        'title': titleController,
                        'content': notesController,
                        'created': currentTime,
                      });
                    
                    });
                    Navigator.pop(context);
                     }
                  },
                  label: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ],
      ),
      body: Container(
          margin: EdgeInsets.all(30.0),
          child: Form(
            key: _formkey,
              child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    titleController = val;
                  });
                },
                validator: (val)=> val.isEmpty ? "title cannot be empty":null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(fontSize: 20.0),
                  //border: InputBorder.none
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    notesController = val;
                  });
                },
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                validator: (val)=> val.isEmpty ? "Notes cannot be empty":null,
                decoration: InputDecoration(
                  hintText: "Notes",
                  
                  hintStyle: TextStyle(fontSize: 20.0),
                  //border: InputBorder.none
                ),
              )
            ],
          ))),
    );
  }
}
