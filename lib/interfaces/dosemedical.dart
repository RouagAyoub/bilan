import 'package:bilanmedic/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class Dosemedic extends StatefulWidget {
  Dosemedic({Key key, this.bilan}) : super(key: key);
  final Map bilan;

  @override
  _DosemedicState createState() => _DosemedicState(bilan);
}

class _DosemedicState extends State<Dosemedic> {
  final Map bilan;
  List<Map> notin = [];
  List<Map> inlist = [];
  List<Map> medilist = [];
  Widget wid = Center(
    child: CircularProgressIndicator(),
  );
  double bilanreglage(String bilan) {
    return double.tryParse(bilan.replaceAll(new RegExp(r"\D"), ""));
  }

  bilantype(regle) {
    double bilantype;
    bool acceptarion;
    double regleregle = bilanreglage(regle['regle']);

    switch (regle['billantype']) {
      case "clairance_renale":
        bilantype = bilanreglage(bilan['clairance']);
        break;
      case "bilirubine":
        bilantype = bilanreglage(bilan['bilirubine']);
        break;
      case "tgo_tgp":
        bilantype = bilanreglage(bilan['tgo']);
        break;
    }
    if (bilantype != null && regleregle != null) {
      switch (regle['reglecompar']) {
        case "<":
          acceptarion = bilantype < regleregle;
          break;
        case ">":
          acceptarion = bilantype > regleregle;
          break;
        case "=":
          acceptarion = bilantype == regleregle;
          break;
      }
    } else {
      acceptarion = false;
    }

    if (acceptarion && !notin.contains(regle)) {
      if (!inlist.contains(regle)) inlist.add(regle);
    } else {
      inlist.remove(regle);
      if (!notin.contains(regle)) notin.add(regle);
    }
  }

  @override
  void initState() {
    getinfo();
    super.initState();
  }

  getinfo() {
    getReglewithmedi().then((List<Map> snapshot) async {
      if (snapshot.isNotEmpty) {
        List.generate(snapshot.length, (index2) async {
          await bilantype(snapshot[index2]);
        });
        setState(() {
          wid = Column(
            children: List.generate(inlist.length, (index3) {
              return Container(
                padding: EdgeInsets.fromLTRB(10, 15, 20, 0),
                child: Card(
                  elevation: 20,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 20, 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          inlist[index3]['namemedicament'],
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        )),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green),
                          child: Text(
                            inlist[index3]['dosemedic'],
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
      } else {
        return Center(child: SingleChildScrollView());
      }
    });
  }

  _DosemedicState(this.bilan);
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: wid));
  }
}

Future<List<Map>> getReglewithmedi() async {
  final Database db = await opendatabase();
  final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM regle , medicament WHERE regle.idmedicament = medicament.idmedicament');
  return List.generate(maps.length, (i) {
    return {
      'idregle': maps[i]['idregle'],
      'idmedicament': maps[i]['idmedicament'],
      'regle': maps[i]['regle'],
      'dosemedic': maps[i]['dosemedic'],
      'billantype': maps[i]['billantype'],
      'reglecompar': maps[i]['reglecompar'],
      'namemedicament': maps[i]['namemedicament']
    };
  });
}
