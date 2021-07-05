import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import '../connexion/connexion.dart';
import '../main.dart';

class ReglePage extends StatefulWidget {
  ReglePage({Key key}) : super(key: key);

  @override
  _ReglePageState createState() => _ReglePageState();
}

List<Map> listregle;

class _ReglePageState extends State<ReglePage> {
  final TextEditingController _searchControl = new TextEditingController();
  int itemnumber;
  List<Widget> list = [];
  String searchname = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
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
                      hintText: "Recherche ",
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
                //get medic tjib les medicament
                future: getMedic(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return LinearProgressIndicator();
                    case ConnectionState.none:
                      return Text('Connexion failed');
                    default:
                      if (snapshot.hasData) {
                        list = List.generate(snapshot.data.length, (index) {
                          if (snapshot.data[index]['namemedicament']
                              .contains(searchname)) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 20),
                              elevation: 20,
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: size.width - 20,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Color(0xFFF57E20),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                  child: Text(snapshot
                                                      .data[index]
                                                          ['namemedicament']
                                                      .toUpperCase())),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () async {
                                                  TextEditingController regle =
                                                      TextEditingController();
                                                  TextEditingController dose =
                                                      TextEditingController();
                                                  String bilandemande =
                                                      "clairance_renale";
                                                  String reglecompar = ">";

                                                  final _formkey =
                                                      GlobalKey<FormState>();

                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            Size size =
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size;
                                                            return Container(
                                                              height:
                                                                  size.height,
                                                              width: size.width,
                                                              child:
                                                                  AlertDialog(
                                                                title: Text(
                                                                    "Ajoutez une Regle ?"),
                                                                content:
                                                                    Container(
                                                                  height:
                                                                      size.height /
                                                                          4,
                                                                  width: size
                                                                      .width,
                                                                  child: Form(
                                                                    key:
                                                                        _formkey,
                                                                    child:
                                                                        Column(
                                                                      verticalDirection:
                                                                          VerticalDirection
                                                                              .down,
                                                                      children: [
                                                                        DropdownButton<
                                                                            String>(
                                                                          value:
                                                                              bilandemande,
                                                                          icon:
                                                                              const Icon(Icons.arrow_downward),
                                                                          iconSize:
                                                                              24,
                                                                          elevation:
                                                                              16,
                                                                          style:
                                                                              const TextStyle(color: Colors.deepPurple),
                                                                          underline:
                                                                              Container(
                                                                            height:
                                                                                2,
                                                                            color:
                                                                                Colors.deepPurpleAccent,
                                                                          ),
                                                                          onChanged:
                                                                              (String newValue) {
                                                                            setState(() {
                                                                              bilandemande = newValue;
                                                                            });
                                                                          },
                                                                          items: <
                                                                              String>[
                                                                            'clairance_renale',
                                                                            'bilirubine',
                                                                            'tgo_tgp',
                                                                          ].map<DropdownMenuItem<String>>((String
                                                                              value) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: value,
                                                                              child: Text(
                                                                                value,
                                                                                style: TextStyle(color: Colors.black),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            DropdownButton<String>(
                                                                              value: reglecompar,
                                                                              icon: Icon(null),
                                                                              iconSize: 24,
                                                                              elevation: 16,
                                                                              style: const TextStyle(color: Colors.deepPurple),
                                                                              underline: Container(
                                                                                height: 2,
                                                                                color: Colors.deepPurpleAccent,
                                                                              ),
                                                                              onChanged: (String newValue) {
                                                                                setState(() {
                                                                                  reglecompar = newValue;
                                                                                });
                                                                              },
                                                                              items: <String>[
                                                                                '>',
                                                                                '<',
                                                                                '='
                                                                              ].map<DropdownMenuItem<String>>((String value) {
                                                                                return DropdownMenuItem<String>(
                                                                                  value: value,
                                                                                  child: Text(
                                                                                    value,
                                                                                    style: TextStyle(color: Colors.black, fontSize: 25),
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                            ),
                                                                            Expanded(
                                                                                child: TextFormField(
                                                                              // ignore: missing_return
                                                                              validator: (value) {
                                                                                if (value == "") {
                                                                                  return "la regle est vide !!";
                                                                                }
                                                                              },
                                                                              controller: regle,
                                                                              decoration: InputDecoration(
                                                                                hintText: 'la Regle ',
                                                                              ),
                                                                            )),
                                                                          ],
                                                                        ),
                                                                        TextFormField(
                                                                          validator:
                                                                              // ignore: missing_return
                                                                              (value) {
                                                                            if (value ==
                                                                                "") {
                                                                              return "la dose est vide !!";
                                                                            }
                                                                          },
                                                                          controller:
                                                                              dose,
                                                                          decoration:
                                                                              InputDecoration(hintText: 'la dose '),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  MaterialButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (_formkey
                                                                            .currentState
                                                                            .validate()) {
                                                                          final Database
                                                                              db =
                                                                              await opendatabase();
                                                                          await db
                                                                              .insert(
                                                                            'regle',
                                                                            {
                                                                              'idmedicament': snapshot.data[index]['idmedicament'],
                                                                              'billantype': bilandemande,
                                                                              'dosemedic': dose.text,
                                                                              'regle': regle.text,
                                                                              'reglecompar': reglecompar
                                                                            },
                                                                            conflictAlgorithm:
                                                                                ConflictAlgorithm.replace,
                                                                          );
                                                                          Navigator.of(context).pop(regle
                                                                              .text
                                                                              .toString());
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          "Add"),
                                                                      elevation:
                                                                          5)
                                                                ],
                                                              ),
                                                            );
                                                          }));
                                                  await getRegle().then(
                                                      (value) =>
                                                          listregle = value);

                                                  setState(() {});
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () async {
                                                  TextEditingController
                                                      medicamentnom =
                                                      TextEditingController();
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Edit medicament ?"),
                                                          content: TextField(
                                                              controller:
                                                                  medicamentnom),
                                                          actions: <Widget>[
                                                            MaterialButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (medicamentnom
                                                                          .text
                                                                          .length >
                                                                      2) {
                                                                    final Database
                                                                        db =
                                                                        await opendatabase();
                                                                    db.update(
                                                                        "medicament",
                                                                        {
                                                                          'namemedicament':
                                                                              medicamentnom.text,
                                                                          'idmedicament':
                                                                              snapshot.data[index]['idmedicament']
                                                                        },
                                                                        where:
                                                                            'idmedicament = ?',
                                                                        whereArgs: [
                                                                          snapshot.data[index]
                                                                              [
                                                                              'idmedicament']
                                                                        ]);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(medicamentnom
                                                                            .text
                                                                            .toString());
                                                                  } else {
                                                                    final snackBar =
                                                                        SnackBar(
                                                                      content: Text(
                                                                          "short name !!"),
                                                                    );
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            snackBar);
                                                                  }
                                                                },
                                                                child: Text(
                                                                    "Edit"),
                                                                elevation: 5)
                                                          ],
                                                        );
                                                      });
                                                  setState(() {});
                                                }),
                                            IconButton(
                                                icon: Icon(Icons
                                                    .highlight_remove_sharp),
                                                onPressed: () async {
                                                  if (await confirm(
                                                    context,
                                                    title:
                                                        Text("Add new Regle ?"),
                                                  )) {
                                                    final Database db =
                                                        await opendatabase();
                                                    db.delete("medicament",
                                                        where:
                                                            'idmedicament = ?',
                                                        whereArgs: [
                                                          snapshot.data[index]
                                                              ['idmedicament']
                                                        ]);
                                                    setState(() {});
                                                  }
                                                }),
                                          ],
                                        )),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 20, bottom: 10),
                                      child: getreglewhere(
                                          snapshot.data[index]['idmedicament'],
                                          context),
                                    )
                                  ],
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
                  }
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await setpref(false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Connexion()),
                (Route<dynamic> route) => false,
              );
            }),
        title: Text('Medicament et Regle'),
        actions: [
          IconButton(
              icon: Icon(Icons.add_box_rounded),
              onPressed: () async {
                TextEditingController medicamentnom = TextEditingController();
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("add new medicament ?"),
                        content: TextField(controller: medicamentnom),
                        actions: <Widget>[
                          MaterialButton(
                              onPressed: () async {
                                if (medicamentnom.text.length > 2) {
                                  final Database db = await opendatabase();
                                  await db.insert(
                                    'medicament',
                                    {'namemedicament': medicamentnom.text},
                                    conflictAlgorithm:
                                        ConflictAlgorithm.replace,
                                  );

                                  Navigator.of(context)
                                      .pop(medicamentnom.text.toString());
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text("short name !!"),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
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
    ));
  }
}

Future<List<Map>> getMedic() async {
  final Database db = await opendatabase();
  final List<Map<String, dynamic>> maps = await db.query('medicament');
  return List.generate(maps.length, (i) {
    return {
      "idmedicament": maps[i]['idmedicament'],
      "namemedicament": maps[i]['namemedicament'],
    };
  });
}

Future<List<Map>> getRegle() async {
  final Database db = await opendatabase();
  final List<Map<String, dynamic>> maps = await db.query('regle');
  return List.generate(maps.length, (i) {
    return {
      "idregle": maps[i]['idregle'],
      "idmedicament": maps[i]['idmedicament'],
      "regle": maps[i]['regle'],
      "dosemedic": maps[i]['dosemedic'],
      "billantype": maps[i]['billantype'],
      "reglecompar": maps[i]['reglecompar']
    };
  });
}

Widget getreglewhere(idmedicament, context1) {
  List<Widget> reglelist = List.generate(
      listregle.length,
      (index) => StatefulBuilder(builder: (context, setState) {
            if (listregle[index]['idmedicament'] == idmedicament) {
              IconData iconvalue;
              switch (listregle[index]['reglecompar'].toString()) {
                case ">":
                  iconvalue = Icons.arrow_forward_ios_rounded;
                  break;
                case "<":
                  iconvalue = Icons.arrow_back_ios_rounded;
                  break;
                case "=":
                  iconvalue = Icons.view_stream_rounded;
              }
              return Container(
                padding: EdgeInsets.only(top: 4),
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(7),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("bilan demander :   "),
                                  Text(
                                    listregle[index]['billantype'].toString() +
                                        "  ",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("condition :             "),
                                  Icon(
                                    iconvalue,
                                    size: 15,
                                  ),
                                  Text(
                                    listregle[index]['regle'],
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("dose donne :        "),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      listregle[index]['dosemedic'],
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              TextEditingController medicamentnom =
                                  TextEditingController();
                              TextEditingController regle =
                                  TextEditingController();
                              TextEditingController dose =
                                  TextEditingController();
                              String bilandemande = "clairance_renale";
                              String reglecompar = ">";
                              final _formkey = GlobalKey<FormState>();
                              await showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                          builder: (context, setState) {
                                        Size size = MediaQuery.of(context).size;
                                        return Container(
                                          height: size.height,
                                          width: size.width,
                                          child: AlertDialog(
                                            title: Text("Ajoutez une Regle ?"),
                                            content: Container(
                                              height: size.height / 4,
                                              width: size.width,
                                              child: Form(
                                                key: _formkey,
                                                child: Column(
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  children: [
                                                    DropdownButton<String>(
                                                      value: bilandemande,
                                                      icon: const Icon(
                                                          Icons.arrow_downward),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .deepPurple),
                                                      underline: Container(
                                                        height: 2,
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                      ),
                                                      onChanged:
                                                          (String newValue) {
                                                        setState(() {
                                                          bilandemande =
                                                              newValue;
                                                        });
                                                      },
                                                      items: <String>[
                                                        'clairance_renale',
                                                        'bilirubine',
                                                        'tgo_tgp',
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    Row(
                                                      children: [
                                                        DropdownButton<String>(
                                                          value: reglecompar,
                                                          icon: Icon(null),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .deepPurple),
                                                          underline: Container(
                                                            height: 2,
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                          ),
                                                          onChanged: (String
                                                              newValue) {
                                                            setState(() {
                                                              reglecompar =
                                                                  newValue;
                                                            });
                                                          },
                                                          items: <String>[
                                                            '>',
                                                            '<',
                                                            '='
                                                          ].map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        25),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        Expanded(
                                                            child:
                                                                TextFormField(
                                                          controller: regle,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'la Regle ',
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                    TextFormField(
                                                      controller: dose,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'la dose '),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              MaterialButton(
                                                  onPressed: () async {
                                                    final Database db =
                                                        await opendatabase();
                                                    db.update(
                                                        "regle",
                                                        {
                                                          'billantype':
                                                              bilandemande,
                                                          'dosemedic':
                                                              dose.text,
                                                          'regle': regle.text,
                                                          'reglecompar':
                                                              reglecompar
                                                        },
                                                        where: 'idregle  = ?',
                                                        whereArgs: [
                                                          listregle[index]
                                                              ['idregle']
                                                        ]);
                                                    Navigator.of(context).pop(
                                                        medicamentnom.text
                                                            .toString());
                                                    await getListregle();
                                                    setState(() {});
                                                  },
                                                  child: Text("Modifier"),
                                                  elevation: 5)
                                            ],
                                          ),
                                        );
                                      }));

                              await getListregle();
                              setState(() {});
                            }),
                        IconButton(
                            icon: Icon(Icons.highlight_remove_rounded),
                            onPressed: () async {
                              if (await confirm(
                                context1,
                                title: Text("suprimer la regle ?"),
                              )) {
                                final Database db = await opendatabase();
                                db.delete("regle",
                                    where: 'idregle = ?',
                                    whereArgs: [listregle[index]['idregle']]);
                                await getListregle();
                                setState(() {});
                              }
                            })
                      ],
                    ),
                  ),
                ),
              );
            } else
              return Padding(
                padding: EdgeInsets.zero,
              );
          }));
  return Column(children: reglelist);
}

getListregle() async {
  await getRegle().then((value) => listregle = value);
}
