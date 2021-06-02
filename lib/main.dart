import 'package:bilanmedic/interfaces/pagecollecteur.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    opendatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medic',
      theme: ThemeData(
        accentColor: Color(0xFFAEB365),
        primaryColor: Color(0xFF00728F),
      ),
      home: PageCollector(),
    );
  }
}

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
