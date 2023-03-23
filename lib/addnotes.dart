import 'package:flutter/material.dart';
import 'sqlflite.dart';
import 'main.dart';

class addNotes extends StatefulWidget {
  addNotes({Key? key}) : super(key: key);
  @override
  State<addNotes> createState() => _addNotesState();
}

class _addNotesState extends State<addNotes> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إضافة ملاحظة"),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Form(
                key: formstate,
                child: Column(children: [
                  TextFormField(
                    controller: note,
                    decoration: InputDecoration(hintText: "اكتب ملاحظتك هنا"),
                  ),
                  TextFormField(
                      controller: title,
                      decoration: InputDecoration(hintText: "اكتب عنوانك هنا")),
                  TextFormField(
                      controller: color,
                      decoration: InputDecoration(hintText: " اللون")),
                  Container(height: 20),
                  MaterialButton(
                    onPressed: () async {
                      int response = await sqlDb.insertData('''
INSERT INTO notes (`note`,`title`,`color`)
VALUES ("${note.text}","${title.text}","${color.text}")
''');
                      if (response > 0) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (route) => false);
                      }
                    },
                    child: Text("أضف ملاحظة"),
                    textColor: Colors.white,
                    color: Colors.blue,
                  )
                ]),
              )
            ],
          )),
    );
  }
}
