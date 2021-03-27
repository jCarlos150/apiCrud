import 'package:cadastroAPI/api/api.dart';
import 'package:cadastroAPI/api/usuario.dart';
import 'package:cadastroAPI/api/usuariosApi.dart';
import 'package:cadastroAPI/home.dart';
import 'package:cadastroAPI/pages.dart/casdastroS.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginaInicial extends StatelessWidget {
  String hash;
  PaginaInicial({this.hash});

  TextEditingController newHash = TextEditingController();

  _deletar(context, Usuario usuario) async {
    var delete = await Api.delete(hash, usuario.sId);

    if (delete) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(usuario.senha);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => PaginaInicial(hash: hash)),
          ModalRoute.withName("/"));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Troca de hash"),
              content: Text("Erro ao apagar"),
              actions: [
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Trocar", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  _trocarHash(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Troca de hash"),
            content: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: newHash,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "New hahs"),
                )),
              ],
            ),
            actions: [
              RaisedButton(
                color: Colors.blue,
                child: Text("Trocar", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaginaInicial(
                                hash: newHash.text.toString(),
                              )),
                      ModalRoute.withName("/"));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagina inicial"),
        actions: [
          RaisedButton(
            child: Text(
              "Logaut",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Home()));
            },
          )
        ],
      ),
      floatingActionButton: RaisedButton(
        child: Text(
          "Trocar hash",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
        onPressed: () {
          _trocarHash(context);
        },
      ),
      body: _body(),
    );
  }

  _body() {
    Future<List<Usuario>> usuarios = Api.getAllProducts(hash);

    return FutureBuilder(
        future: usuarios,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text("Erro ao carregar os dados"),
              );
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              List<Usuario> usuarios = snapshot.data;

              if (usuarios == null) {
                return Center(
                  child: Text("Error no hash. Altere o hash"),
                );
              }

              return _listaUsuarios(usuarios);
          }
        });
  }

  _listaUsuarios(usuarios) {
    return ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          Usuario user = usuarios[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      title: Text("Nome :" + user.nome.toString()),
                      subtitle: Text("Email " + user.email.toString()),
                      leading: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Cadastro(
                                            iduser: user.sId,
                                          )));
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              _deletar(context, user);
                            },
                            icon: Icon(Icons.remove_circle),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
}
