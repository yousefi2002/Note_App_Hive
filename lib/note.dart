import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  Note( this.title,  this.description,  [this.date]);
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String? date;
}
