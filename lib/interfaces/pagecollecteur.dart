import 'package:bilanmedic/interfaces/bilaninterface.dart';
import 'package:bilanmedic/interfaces/reglepage.dart';
import 'package:flutter/material.dart';

class PageCollector extends StatefulWidget {
  PageCollector({Key key}) : super(key: key);

  @override
  _PageCollectorState createState() => _PageCollectorState();
}

class _PageCollectorState extends State<PageCollector>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  static TabController _tabController;

  @override
  void initState() {
    getListregle();
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Color(0xFF00728F),
        selectedItemColor: Color(0xFFD7D513),
        unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          _tabController.animateTo(value);
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'medicament',
            icon: Icon(
              Icons.medical_services,
            ),
          ),
          BottomNavigationBarItem(
            label: 'bilan',
            icon: Icon(
              Icons.list_alt_rounded,
            ),
          ),
        ],
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[ReglePage(), BilanInterface()]),
    ));
  }
}
