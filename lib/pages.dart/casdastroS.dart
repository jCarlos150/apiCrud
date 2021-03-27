import 'dart:convert';

import 'package:cadastroAPI/api/api.dart';
import 'package:cadastroAPI/home.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cadastro extends StatelessWidget {
  String iduser;

  Cadastro({this.iduser});

  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _dataN = TextEditingController();
  final _senha = TextEditingController();
  final _hash = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String textToMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  _salvarId(nome, email, senha, data, hash, BuildContext context) async {
    if (iduser != null) {
      String key = textToMd5(email + senha);
      String res =
          await Api.alterarUsuario(iduser, nome, email, data, key, hash);

      if (res != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(res);
        await prefs.setString(key, iduser);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(""),
                content: Text("Salvo com sucesso"),
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
                content: Text("Erro ao salvar os dados  verifique o hash"),
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
    } else {
      String key = textToMd5(email + senha);
      String id = await Api.cadastro(nome, email, data, key, hash);

      if (id != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, id);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(""),
                content: Text("Salvo com sucesso"),
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
                content: Text("Erro ao salvar os dados  verifique o hash"),
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

    //String key = textToMd5(email + senha);
    //await prefs.setString(key, id);
    //String a = prefs.getString(key);
    //print(a);
  }

  _logout(context) {
    return RaisedButton(
      child: Text(
        "Logaut",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blue,
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            ModalRoute.withName("/"));
      },
    );
  }

  _icon() {
    return Icon(
      Icons.integration_instructions_sharp,
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            iduser != null ? "Editar Usuario" : "Cadastrar usuario",
            style:
                TextStyle(color: iduser != null ? Colors.white : Colors.blue),
          ),
          backgroundColor: iduser != null ? Colors.blue : Colors.white,
          actions: [iduser != null ? _logout(context) : _icon()]),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _body(context),
      ),
    );
  }

  String _validateNome(String text) {
    if (text.isEmpty) {
      return "Informe o nome";
    }
    return null;
  }

  String _validateEmail(String text) {
    if (text.isEmpty) {
      return "Informe o email";
    }
    return null;
  }

  String _validateData(String text) {
    if (text.isEmpty) {
      return "Informe a data de Nascimento";
    }
    return null;
  }

  String _validateHash(String text) {
    if (text.isEmpty) {
      return "Informe o hash";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Informe a senha";
    }
    return null;
  }

  _body(BuildContext context) {
    return Form(
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
            textFormFieldNome(),
            textFormFieldEmail(),
            textFormFieldData(),
            textFormFieldSenha(),
            containerButton(context),
          ],
        ));
  }

  TextFormField textFormFieldNome() {
    return TextFormField(
      controller: _nome,
      validator: _validateNome,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: "Nome",
          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
          hintText: "preencha o nome"),
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

  TextFormField textFormFieldData() {
    return TextFormField(
      controller: _dataN,
      validator: _validateData,
      keyboardType: TextInputType.datetime,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: "Data de nascimento",
          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
          hintText: "preencha a data de nascimento"),
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
          labelText: "Senha",
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
          iduser != null ? "Editar" : "Cadastrar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          _onClickLogin(context);
        },
      ),
    );
  }

  _onClickLogin(BuildContext context) async {
    final nomeT = _nome.text;
    final emailT = _email.text;
    final dataT = _dataN.text;
    final senha = _senha.text;
    final h = _hash.text;

    if (h == null) {
      print("entrou aqui");
    }

    if (!_formKey.currentState.validate()) {
      return;
    }

    print(h.toString());

    _salvarId(nomeT.toString(), emailT.toString(), senha.toString(),
        dataT.toString(), h.toString(), context);
  }
}
