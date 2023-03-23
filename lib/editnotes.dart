import 'dart:ffi';

import 'package:flutter/material.dart';
import 'sqlflite.dart';
import 'main.dart';

class EditNotes extends StatefulWidget {
  final note;
  final title;
  final id;
  final color;
  EditNotes({Key? key, this.id, this.note, this.title, this.color})
      : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController color = TextEditingController();
  @override
  void initState() {
    note.text = widget.note;
    title.text = widget.title;
    color.text = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تعديل الملاحظة"),
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
                      int response = await sqlDb.updateData('''
UPDATE notes SET
 note="${note.text}",
 title="${title.text}",
 color="${color.text}"
WHERE id="${widget.id}"
''');
                      if (response > 0) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (route) => false);
                      }
                    },
                    child: Text("عدًل"),
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
