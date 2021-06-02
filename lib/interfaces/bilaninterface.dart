import 'package:bilanmedic/interfaces/dosemedical.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import '../main.dart';

class BilanInterface extends StatefulWidget {
  BilanInterface({Key key}) : super(key: key);

  @override
  _BilanInterfaceState createState() => _BilanInterfaceState();
}

Future<List<Map>> getbilan() async {
  final Database db = await opendatabase();
  final List<Map<String, dynamic>> maps = await db.query('bilan');
  return List.generate(maps.length, (i) {
    return {
      "idbilan": maps[i]['idbilan'],
      "patientnom": maps[i]['patientnom'],
      "bilirubine": maps[i]['bilirubine'],
      "clairance": maps[i]['clairance'],
      "tgo": maps[i]['tgo']
    };
  });
}

class _BilanInterfaceState extends State<BilanInterface> {
  final TextEditingController _searchControl = new TextEditingController();
  int itemnumber;
  List<Widget> list = [];
  String searchname = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Bilan'),
        actions: [
          IconButton(
              icon: Icon(Icons.add_box_rounded),
              onPressed: () async {
                TextEditingController patientname = TextEditingController();
                TextEditingController bilur = TextEditingController();
                TextEditingController clairance = TextEditingController();
                TextEditingController tg = TextEditingController();
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("ajouter bilan ?"),
                        content: Column(
                          children: [
                            TextFormField(
                              controller: patientname,
                              decoration:
                                  InputDecoration(hintText: 'patient nom'),
                            ),
                            TextFormField(
                              controller: clairance,
                              decoration:
                                  InputDecoration(hintText: 'clairance rénale'),
                            ),
                            TextFormField(
                              controller: bilur,
                              decoration:
                                  InputDecoration(hintText: ' bilirubine'),
                            ),
                            TextFormField(
                              controller: tg,
                              decoration:
                                  InputDecoration(hintText: ' la tgo/tgp'),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          MaterialButton(
                              onPressed: () async {
                                final Database db = await opendatabase();
                                await db.insert(
                                  'bilan',
                                  {
                                    'patientnom': patientname.text,
                                    'bilirubine': bilur.text ?? " ",
                                    'clairance': clairance.text ?? " ",
                                    'tgo': tg.text ?? " "
                                  },
                                  conflictAlgorithm: ConflictAlgorithm.replace,
                                );
                                Navigator.of(context)
                                    .pop(patientname.text.toString());
                              },
                              child: Text("Add"),
                              elevation: 5)
                        ],
                      );
                    });
                setState(() {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Card(
                elevation: 15.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: "Search..",
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                    onChanged: (value) {
                      setState(() {
                        searchname = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90, left: 30, right: 30),
              child: FutureBuilder<List<Map>>(
                future: getbilan(),
                //initialData: ,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                  if (snapshot.hasData) {
                    list = List.generate(snapshot.data.length, (index) {
                      if (snapshot.data[index]['patientnom']
                          .contains(searchname)) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 20),
                          elevation: 20,
                          color: Colors.grey.shade100,
                          child: Center(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      width: size.width - 20,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xFFD7D513),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Center(
                                                child: Text(snapshot.data[index]
                                                        ['patientnom']
                                                    .toUpperCase())),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.list_alt),
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          content: Container(
                                                        width: 900,
                                                        child: Dosemedic(
                                                          bilan: snapshot
                                                              .data[index],
                                                        ),
                                                      ));
                                                    });
                                              }),
                                          IconButton(
                                              icon: Icon(
                                                  Icons.highlight_remove_sharp),
                                              onPressed: () async {
                                                if (await confirm(context,
                                                    title:
                                                        Text("sur suprimer ?"),
                                                    content: Text(
                                                        "suprimer ce bilan ? "))) {
                                                  final Database db =
                                                      await opendatabase();
                                                  db.delete('bilan',
                                                      where: 'idbilan = ?',
                                                      whereArgs: [
                                                        snapshot.data[index]
                                                            ['idbilan']
                                                      ]);
                                                  setState(() {});
                                                }
                                              })
                                        ],
                                      )),
                                  Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("type de Bilan  : "),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      "Clairance rénale",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("resultat de bilan :"),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10,
                                                        left: 10,
                                                        bottom: 7,
                                                        top: 7),
                                                    padding: EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      snapshot.data[index]
                                                          ['clairance'],
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              TextEditingController bilantext =
                                                  TextEditingController();
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Edit bilan ?"),
                                                      content: TextField(
                                                          controller:
                                                              bilantext),
                                                      actions: <Widget>[
                                                        MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              final Database
                                                                  db =
                                                                  await opendatabase();
                                                              db.update(
                                                                  "bilan",
                                                                  {
                                                                    "clairance":
                                                                        bilantext
                                                                            .text
                                                                  },
                                                                  where:
                                                                      'idbilan = ?',
                                                                  whereArgs: [
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'idbilan']
                                                                  ]);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(bilantext
                                                                      .text
                                                                      .toString());
                                                            },
                                                            child: Text("Edit"),
                                                            elevation: 5)
                                                      ],
                                                    );
                                                  });
                                              setState(() {});
                                            }),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("type de Bilan  : "),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      " la bilirubine",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("resultat de Bilan  : "),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10,
                                                        left: 10,
                                                        bottom: 7,
                                                        top: 7),
                                                    padding: EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      snapshot.data[index]
                                                          ['bilirubine'],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              TextEditingController bilantext =
                                                  TextEditingController();
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Edit bilan ?"),
                                                      content: TextField(
                                                          controller:
                                                              bilantext),
                                                      actions: <Widget>[
                                                        MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              final Database
                                                                  db =
                                                                  await opendatabase();
                                                              db.update(
                                                                  "bilan",
                                                                  {
                                                                    "bilirubine":
                                                                        bilantext
                                                                            .text
                                                                  },
                                                                  where:
                                                                      'idbilan = ?',
                                                                  whereArgs: [
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'idbilan']
                                                                  ]);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(bilantext
                                                                      .text
                                                                      .toString());
                                                            },
                                                            child: Text("Edit"),
                                                            elevation: 5)
                                                      ],
                                                    );
                                                  });
                                              setState(() {});
                                            }),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("type de Bilan  : "),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      " la tgo/tgp",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("resultat de Bilan  : "),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10,
                                                        left: 10,
                                                        bottom: 7,
                                                        top: 7),
                                                    padding: EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      snapshot.data[index]
                                                          ['tgo'],
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () async {
                                              TextEditingController bilantext =
                                                  TextEditingController();
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text("Edit bilan ?"),
                                                      content: TextField(
                                                          controller:
                                                              bilantext),
                                                      actions: <Widget>[
                                                        MaterialButton(
                                                            onPressed:
                                                                () async {
                                                              final Database
                                                                  db =
                                                                  await opendatabase();
                                                              db.update(
                                                                  "bilan",
                                                                  {
                                                                    "tgo":
                                                                        bilantext
                                                                            .text
                                                                  },
                                                                  where:
                                                                      'idbilan = ?',
                                                                  whereArgs: [
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'idbilan']
                                                                  ]);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(bilantext
                                                                      .text
                                                                      .toString());
                                                            },
                                                            child: Text("Edit"),
                                                            elevation: 5)
                                                      ],
                                                    );
                                                  });

                                              setState(() {});
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    });

                    return Column(
                      children: list,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
