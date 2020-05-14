import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/addNote.dart';
import 'package:notes/data.dart';
import 'package:notes/editNote.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static var now = DateTime.now();
  static String currentTime = DateFormat("dd-MM-yyyy hh:mm").format(now);

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: FutureBuilder(
          future: NoteProvider.getDetails(),
          builder: (context, snapshot) {
            final notes = snapshot.data;
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(children: [
                Expanded(
                    flex: 35,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          stretch: true,
                          pinned: true,
                          floating: true,
                          
                          expandedHeight:
                              MediaQuery.of(context).size.height * 0.35,
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: EdgeInsets.zero,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                
                                Padding(
                                  padding: const EdgeInsets.only(top:20.0),
                                  child: Text('Nish Notes'),
                                ),
                                Text(notes.length.toString()+" notes",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400
                                ),
                                )
                              ],
                            ),
                            centerTitle: true,
                          ),
                        ),
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: MediaQuery.of(context).size.width*0.5,
                            //mainAxisSpacing: 10.0,
                            //crossAxisSpacing: 10.0,
                            //childAspectRatio: 4.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                child: NoteCard(
                                  noteTitle: notes[index]['title'],
                                  content: notes[index]['content'],
                                  created: notes[index]['created'],
                                  id: notes[index]['id'],
                                ),
                              );
                            },
                            childCount: notes.length,
                          ),
                        ),
                      ],
                    )),
              ]);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddNote()));
          },
          tooltip: 'Add New Note',
          child: Icon(
            Icons.add,
          ),
        ));
  }
}

class NoteCard extends StatelessWidget {
  final String noteTitle;
  final String content;
  final String created;
  final int id;
  NoteCard({this.id, this.noteTitle, this.content, this.created});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditNote(
                      id: id,
                    )));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(noteTitle,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                subtitle: Text("Created: "+created,
                style: TextStyle(
                  fontSize: 10.0,
                ),
                ),
              ),
              //content.length<30 ? Text(content):Text(content.substring(0,30)+"..."),
              Text(
                content,
                style: TextStyle(
                  fontSize: 15.0
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
