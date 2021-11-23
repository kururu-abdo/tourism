import 'dart:io';

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'package:tourapp/core/enums/trip_status.dart';
import 'package:tourapp/core/models/trip.dart';

import 'notifications.dart';
class DBHelper {
  DBHelper._();

  static final DBHelper db = DBHelper._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notifications.db");
    return await openDatabase(path, version: 1,   onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE trip ("
              "id INTEGER PRIMARY KEY  AUTOINCREMENT ,"
              "location TEXT  ,"
              "lat   REAL  ,"
           "date TEXT  ,"
              "lon   REAL  ,"
              "message  TEXT,"
              "status  TEXT) ");
        });
  }
  //INSERT
  Future<int> add(Trip    model) async {
    var dbClient = await database;
var raw = await dbClient.rawInsert(
        "INSERT Into trip (location,lat , lon   ,  date   ,status     ,message)"
        " VALUES (?,?,?,? ,?,?)",
        [

          model.location,
          model.lat,
          model.lon,
          model.date,
          TripStatus.values[model.status.index].toString(),
          model.message
        ]);
print(raw);
                   await    createWaterReminderNotification(

                         Trip(
                           id: raw ,
                           location:  model.location ,  lat:  model.lat ,  lon:  model.lon ,message:  model.message, date: model.date   )



                    );
    return raw;
  }

  //READ

  Future<List<Trip>> getAllScheduledTrips() async {
    var dbClient = await database;
    //where: "isread=?",  whereArgs:[1]
    List<Map> maps =
        await dbClient.query('trip', orderBy: "id  DESC");
    List<Trip> notfocations = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        notfocations.add(Trip.fromJson(maps[i]));
        print(maps[i]);
      }
    }
    print(notfocations);
    return notfocations;
  }


//UPDATE
    Future<int> update(Trip   model) async {
    var dbClient = await database;
    return await dbClient.update(
      'trip',
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }



  //DELETE
Future<int> delete(int id) async {
    var dbClient = await database;
    return await dbClient.delete(
      'trip',
      where: 'id = ?',
      whereArgs: [id],
    );
  }




  //CLOSE

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}