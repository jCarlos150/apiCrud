import 'package:cadastroAPI/pages.dart/casdastroS.dart';
import 'package:cadastroAPI/pages.dart/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
          tabs: <Widget>[Tab(text: "Login"), Tab(text: "Cadastro")],
        )),
        body: TabBarView(
          children: [
            new Container(
              child: new Login(),
            ),
            new Container(
              child: new Cadastro(),
            )
          ],
        ),
      ),
    );
  }
}
