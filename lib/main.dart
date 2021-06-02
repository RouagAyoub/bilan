import 'package:bilanmedic/connexion/connexion.dart';
import 'package:bilanmedic/interfaces/pagecollecteur.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

//save login preferences
SharedPreferences _pref;

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget hp = CircularProgressIndicator();
  logorhom() async {
    getpref().then((value) async {
      if (value == null) {
        await setpref(false);
      }
      if (value) {
        setState(() {
          hp = PageCollector();
        });
      } else {
        setState(() {
          hp = Connexion();
        });
      }
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
  }

  void initState() {
    logorhom();
    opendatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Houssem Benzehda',
      theme: ThemeData(
        accentColor: Color(0xFFAEB365),
        primaryColor: Color(0xFF00728F),
      ),
      home: hp,
    );
  }
}

// create data base takhdem la base de donne
opendatabase() async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'docman_database.db'),
    onCreate: (db, version) {
      db.execute(
          "CREATE TABLE IF NOT EXISTS user(iduser INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT,password TEXT)");
      db.insert(
        "user",
        {"username": "admin", "password": "password2121"},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      db.execute(
          "CREATE TABLE IF NOT EXISTS bilan(idbilan INTEGER PRIMARY KEY AUTOINCREMENT, clairance TEXT, bilirubine TEXT,tgo TEXT,patientnom TEXT)");
      db.execute(
          "CREATE TABLE IF NOT EXISTS medicament (idmedicament INTEGER PRIMARY KEY AUTOINCREMENT, namemedicament TEXT)");
      return db.execute(
        "CREATE TABLE IF NOT EXISTS regle(idregle INTEGER PRIMARY KEY AUTOINCREMENT, idmedicament INTEGER, regle TEXT,dosemedic TEXT,billantype TEXT,reglecompar TEXT)",
      );
    },
    version: 2,
  );

  return database;
}

//get login value true or false ydir test l login
Future<bool> getpref() async {
  try {
    _pref = await SharedPreferences.getInstance();
    final String key = "login";
    final value = _pref.getBool(key);
    if (value == null) {
      return false;
    } else {
      return value;
    }
  } catch (e) {
    return false;
  }
}

// save login value
setpref(value) async {
  try {
    _pref = await SharedPreferences.getInstance();
    final String key = "login";
    _pref.setBool(key, value);
  } catch (e) {}
}
