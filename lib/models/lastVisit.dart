import 'package:twodayrule/services/Database.dart';

class LastVisit {
  final int id;
  final String lastVisit;

  LastVisit({
    this.id,
    this.lastVisit,
  });

  factory LastVisit.fromMap(Map<String, dynamic> map) => LastVisit(
        id: map[DBProvider.GENERAL_COLUMN_ID],
        lastVisit: map[DBProvider.GENERAL_COLUMN_LASTVISIT],
      );

  Map<String, dynamic> toMap() => {
        DBProvider.GENERAL_COLUMN_ID: id,
        DBProvider.GENERAL_COLUMN_LASTVISIT: lastVisit,
      };
}
