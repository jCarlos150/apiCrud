import 'dart:convert';

import 'package:cadastroAPI/api/api.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecuperarSenha extends StatelessWidget {
  final _hash = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String textToMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  void _logar(email, senha, hash, BuildContext context) async {
    String key = textToMd5(email + senha);
    String oddSenha = await Api.alterarSenha(hash, email, key);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (oddSenha != null) {
      String id = prefs.getString(oddSenha);
      prefs.remove(oddSenha);
      prefs.setString(key, id);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(""),
              content: Text("Senha alterada com sucesso"),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(""),
              content:
                  Text("Erro ao logar verifique o hash ou as credenciaias"),
              actions: <Widget>[
                FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        },
      );
    }
  }

  String _validateEmail(String text) {
    if (text.isEmpty) {
      return "Informe o email";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Informe a senha";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recuperar Senha"),
        ),
        body: _body(context));
  }

  _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              RaisedButton(
                child: Text(
                  "Preencha o hash",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text("Preencha o hash"),
                          content: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _hash,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "hash",
                                      labelStyle: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      hintText: "hash"),
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ]);
                    },
                  );
                },
                color: Colors.blue,
              ),
              textFormFieldEmail(),
              textFormFieldSenha(),
              containerButton(context),
            ],
          )),
    );
  }

  TextFormField textFormFieldEmail() {
    return TextFormField(
      controller: _email,
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
          hintText: "preencha o email"),
    );
  }

  TextFormField textFormFieldSenha() {
    return TextFormField(
      controller: _senha,
      validator: _validateSenha,
      keyboardType: TextInputType.text,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: "Nova senha",
          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
          hintText: "preencha a senha"),
    );
  }

  Container containerButton(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(top: 10),
      child: RaisedButton(
        color: Colors.blue,
        child: Text(
          "Recuperar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          _onClickLogin(context);
        },
      ),
    );
  }

  _onClickLogin(BuildContext context) {
    final emailT = _email.text;
    final senha = _senha.text;
    final h = _hash.text;

    if (!_formKey.currentState.validate()) {
      return;
    }
    _logar(emailT.toString(), senha.toString(), h, context);
  }
}
