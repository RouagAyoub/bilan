import 'package:bilanmedic/main.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image(image: AssetImage('assets/doctor.jpg')),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, size.height / 2.5, 20, 0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: 25.0,
                    ),
                    child: Text(
                      "S 'identifier",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Column(
                    children: [
                      Card(
                        elevation: 3.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
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
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Nom d'utilisateur",
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.length < 2) {
                                return "Votre Nom d'utilisateur est incorrect !";
                              }
                            },
                            obscureText: false,
                            maxLines: 1,
                            controller: _username,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 3.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
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
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Mot de passe ",
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.length < 6) {
                                return 'Votre Mot de passe est incorrect !';
                              }
                            },
                            obscureText: false,
                            maxLines: 1,
                            controller: _password,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    height: 50.0,
                    child: ElevatedButton(
                      child: Text(
                        "Identifier".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        final Database db = await opendatabase();
                        final List<
                            Map<String,
                                dynamic>> maps = await db.rawQuery(
                            "SELECT * FROM user WHERE username = '${_username.text}' AND password = '${_password.text}' ");
                        print(maps.toString());
                        if (maps.isNotEmpty) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => null),
                            (Route<dynamic> route) => true,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
