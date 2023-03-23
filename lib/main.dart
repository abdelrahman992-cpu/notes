import 'dart:async';
import 'package:noto/addnotes.dart';
import 'package:noto/editnotes.dart';

import 'sqlflite.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      title: 'Sqlflite',
      routes: {
        "addnotes": (context) => addNotes(),
      },
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  bool isLoading = true;
  List notes = [];
  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM notes");
    notes.addAll(response);
    isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
    return response;
  }

  void initState() {
    readData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("homepage"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        child: Icon(Icons.add),
      ),
      body: isLoading == true
          ? Center(child: Text("Loading........"))
          : Container(
              child: ListView(
                children: [
                  MaterialButton(
                      onPressed: () async {
                        await sqlDb.mydeleteDatabase();
                      },
                      child: Text("Delete Database")),
                  ListView.builder(
                      itemCount: notes.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                              title: Text("${notes[i]['title']}"),
                              subtitle: Text("${notes[i]['note']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        int response = await sqlDb.deleteData(
                                            "DELETE FROM notes WHERE id=${notes[i]['id']}");
                                        if (response > 0) {
                                          notes.removeWhere((element) =>
                                              element['id'] == notes[i]['id']);
                                          setState(() {});
                                        }
                                      },
                                      icon:
                                          Icon(Icons.close, color: Colors.red)),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => EditNotes(
                                                      color: notes[i]['color'],
                                                      note: notes[i]['note'],
                                                      title: notes[i]['title'],
                                                      id: notes[i]['id'],
                                                    )));
                                      },
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue)),
                                ],
                              )),
                        );
                      })
                ],
              ),
            ),
    );
  }
}
