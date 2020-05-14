import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data.dart';

class EditNote extends StatefulWidget {
  final int id;
  EditNote({this.id});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  String titleController;
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
        //backgroundColor: Colors.grey[200],
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.delete,
              color: Colors.red,
              ),
              onPressed: () {
                showDialog(context:context, builder: (context){
                  return AlertDialog(
                  shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                  title: Text("You are deleting a note"),
                  content: Text("Do you wish to continue? "),
                  actions: <Widget>[
                    FlatButton(onPressed: (){
                  setState(() {
                   NoteProvider.deleteNote(widget.id);
                   Navigator.pop(context);      
                  });
                 
                
                Navigator.pop(context);
                    }, child: Text("Yes")),
                     FlatButton(onPressed: (){
                       Navigator.pop(context);
                     }, child: Text("No"))
                  ],
                );
                });  
               
                
              },
              label: Text(
                "Delete",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )),
          FlatButton.icon(
              icon: Icon(Icons.save,
              color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  NoteProvider.updateData({
                    'id': widget.id,
                    'title': titleController,
                    'content': notesController,
                    'updated': currentTime
                  });
                });
                Navigator.pop(context);
              },
              label: Text(
                "Save",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
      body: FutureBuilder(
        future: NoteProvider.getNotes(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final note = snapshot.data;
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.all(30.0),
                        child: Form(
                            child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: note[index]['title'],
                              onChanged: (val) {
                                setState(() {
                                  titleController = val;
                                });
                              },
                              readOnly: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20.0),
                                //border: InputBorder.none
                              ),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              initialValue: note[index]['content'],
                              onChanged: (val) {
                                setState(() {
                                  notesController = val;
                                });
                              },
                              readOnly: false,
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 20.0),
                                //border: InputBorder.none
                              ),
                            ),
                      SizedBox(height: 20.0),
                      Text("Created: "+ note[index]['created']),
                      SizedBox(height: 5.0,),
                      note[index]['updated']==null ? Text(""):Text("Updated: "+note[index]['updated'])
                          
                          ],
                        )));
                  });
            } else {
              return Text("No data");
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
