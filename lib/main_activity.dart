import 'package:flutter/material.dart';
import 'package:note_app_hive/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_notes.dart';
import 'log_in_page.dart';
import 'dart:async';
import 'note.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  TextEditingController searchController = TextEditingController();
  List<Note> filteredNotes = [];

  bool isSearching = false;
  int count = 0;
  bool isDarkMode = false;
  String fontStyle = 'bodoniModa';
  double fontSize = 12.0;
  Color color = Color(0xff040542);
  late Note boxNote;
  @override
  void initState() {
    super.initState();
    saveFont();
    loadPreferences();
  }
  void search(String query) {
    final searchResults = noteBox.values.cast<Note>()
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredNotes = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: Text(
          'Notes',
          style: TextStyle(color: color),
        ),
        bottom: isSearching == true
            ? PreferredSize(
                preferredSize: Size.fromHeight(25),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SearchBar(
                    leading: const Icon(Icons.search_sharp, color: Color(0xff040542),),
                    hintText: 'search note',
                    controller: searchController,
                    constraints:
                        const BoxConstraints(maxWidth: 150, minHeight: 35),
                    onChanged: (value) {
                     search(value);
                    },
                  ),
                ),
              )
            : null,
        actions: [
          IconButton(
            tooltip: 'Search',
            color: color,
            onPressed: () {
              setState(() {
                isSearching == false ? isSearching = true : isSearching = false;
                if (!isSearching) {
                  searchController.clear();
                }
              });
            },
            icon: Icon(isSearching ? Icons.expand_less : Icons.search),
          ),
          IconButton(
              color: color,
              tooltip: 'Delete All',
              onPressed: () async{
                await noteBox.clear();
                setState(() {
                });
              } ,
              icon: Icon(Icons.delete_forever_rounded)),
          IconButton(
            color: color,
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            color: color,
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: noteBox.isEmpty && !isSearching?
      Center(
              child: Text(
              'No Notes Available',
              style: TextStyle(
                fontSize: 35,
                color: color,
              ),
            ))
          : isSearching && filteredNotes.isEmpty ?
      Center(
          child: Text(
            'No Notes Available',
            style: TextStyle(
              fontSize: 35,
              color: color,
            ),
          ))
          :
      ListView.builder(
              itemCount: isSearching ? filteredNotes.length : noteBox.length,
              itemBuilder: (context, index) {
                boxNote =  isSearching ? filteredNotes[index] : noteBox.getAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      navigateToAddNote(boxNote, 'Edit Detail');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[500]!,
                            offset: Offset(-4, -4),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(4, 4),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  boxNote.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: color),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    boxNote.date!,
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14,
                                        color: color),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            boxNote.description,
                            style: TextStyle(
                                fontSize: fontSize,
                                fontFamily: fontStyle,
                                color: color),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  noteBox.deleteAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[400],
        onPressed: () {
          navigateToAddNote(Note('', ''), 'Add Note');
        },
        child: Icon(
          Icons.add,
          color: color,
        ),
      ),
    );
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> saveFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontStyle = prefs.getString('fontStyle') ?? 'bodoniModa';
      fontSize = prefs.getDouble('fontSize') ?? 12.0;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('log_in', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void navigateToAddNote(Note note, String title) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddNotePage(note, title)));
    if (result == true) {
      setState(() {
      });
    }
  }
}
