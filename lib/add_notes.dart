import 'package:flutter/material.dart';
import 'package:note_app_hive/main.dart';
import 'note.dart';

class AddNotePage extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  const AddNotePage(this.note, this.appBarTitle, {super.key});

  @override
  _AddNotePageState createState() =>
      _AddNotePageState(this.note, this.appBarTitle);
}

class _AddNotePageState extends State<AddNotePage> {
  String appBarTitle;
  Note note;
  Color color = Color(0xff040542);

  _AddNotePageState(this.note, this.appBarTitle);

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _formattedDate = '';
  String? _formattedTime = '';

  @override
  void initState() {
    super.initState();
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _formattedDate = '${now.year}-${now.month}-${now.day}';
      _formattedTime = '${now.hour}:${now.minute}:${now.second}';
    });
  }

  void saveNote() {
    final existingKey = noteBox.keys.firstWhere(
            (key) => noteBox.get(key).title == _topicController.text,
        orElse: () => null);

    if (existingKey != null) {
      // Update the existing note
      noteBox.put(existingKey, Note(_topicController.text, _descriptionController.text, '''
        $_formattedDate
        $_formattedTime
      '''));
    } else {
      // Add a new note
      noteBox.put('key_${_topicController.text}',
          Note(_topicController.text, _descriptionController.text, '''
        $_formattedDate
        $_formattedTime
      '''));
    }

    Navigator.of(context).pop(true);
  }


  @override
  Widget build(BuildContext context) {
    _topicController.text = note.title;
    _descriptionController.text = note.description;
    _updateDateTime();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        foregroundColor: color,
        backgroundColor: Colors.grey[400],
        title: Text(appBarTitle),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            bottom: 350,
            child: Container(
              width: 500,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xff040542),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 320,
              height: 450,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(4, 4),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _topicController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: color),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: color),
                            borderRadius: BorderRadius.circular(25)),
                        labelText: 'Topic',
                        labelStyle: TextStyle(color: color),
                      ),
                      onChanged: (value) {
                        setState(() {
                          note.title = _topicController.text;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: color),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: color),
                            borderRadius: BorderRadius.circular(25)),
                        labelText: 'Description',
                        labelStyle: TextStyle(color: color),
                      ),
                      onChanged: (value) {
                        setState(() {
                          note.description = _descriptionController.text;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: color,
                        backgroundColor: Colors.grey[300],
                        elevation: 15,
                      ),
                      onPressed: () {
                        if (_topicController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.grey[400],
                              content: Text(
                                  'The topic and the description can\'nt be empty',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          );
                        } else if (_descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.grey[400],
                              content: Text(
                                  'The topic and the description can\'nt be empty',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          );
                        } else {
                          setState(() {
                            saveNote();
                          });
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
