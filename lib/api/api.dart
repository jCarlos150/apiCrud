import 'dart:convert';

import 'package:cadastroAPI/api/usuario.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<String> cadastro(
      String nome, String email, String nasc, String senha, hash) async {
    var url = "https://crudcrud.com/api/$hash/usuario";

    var header = {"Content-Type": "application/json"};

    Map corpo = {"nome": nome, "email": email, "senha": senha, "dataNas": nasc};

    var req = json.encode(corpo);

    print("enviando json: $corpo");

    try {
      var response = await http.post(url, headers: header, body: req);

      Map<String, dynamic> res = json.decode(response.body);

      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        String id = res["_id"].toString();
        return id;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> login(id, hash) async {
    var url = "https://crudcrud.com/api/$hash/usuario/$id";

    try {
      var response = await http.get(url);

      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<Usuario>> getAllProducts(hash) async {
    var url = "https://crudcrud.com/api/$hash/usuario";

    try {
      var response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List usuariosAll = json.decode(response.body);

        final usuarios = <Usuario>[];

        for (Map map in usuariosAll) {
          Usuario user = Usuario.fromJson(map);
          usuarios.add(user);
        }

        return usuarios;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> alterarUsuario(
      id, nome, email, nasc, senha, hash) async {
    var url = "https://crudcrud.com/api/$hash/usuario/$id";

    var header = {"Content-Type": "application/json"};

    Map corpo = {"nome": nome, "email": email, "senha": senha, "dataNas": nasc};

    var req = json.encode(corpo);

    //print(id);

    //print("enviando json: $corpo");

    try {
      print(url);
      var oldUserRequest = await http.get(url);
      //print("old");
      //print(oldUserRequest.statusCode);
      //print(oldUserRequest.body);

      if (oldUserRequest.statusCode == 200 ||
          oldUserRequest.statusCode == 201) {
        print("entrou aqui");
        Map<String, dynamic> oldUser = json.decode(oldUserRequest.body);

        var old = oldUser["senha"];

        var response = await http.put(url, headers: header, body: req);
        //print("put");
        //print(response.statusCode);

        if (response.statusCode == 201 || response.statusCode == 200) {
          return old.toString();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> alterarSenha(hash, email, novaSenha) async {
    var url = "https://crudcrud.com/api/$hash/usuario";
    var header = {"Content-Type": "application/json"};
    String senhaId;

    try {
      var response = await http.get(url);

      print("old");

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List usuariosAll = json.decode(response.body);

        final usuarios = <Usuario>[];

        for (Map map in usuariosAll) {
          Usuario user = Usuario.fromJson(map);
          usuarios.add(user);
        }

        Usuario changeU;

        usuarios.forEach((usuario) {
          String em = usuario.email.toString();
          if (em == email) {
            senhaId = usuario.senha;
            changeU = usuario;
            print(em);
          }
        });

        //print("senha");
        //print(changeU.senha);

        //print("id");
        //print(changeU.sId);

        if (changeU != null) {
          changeU.senha = novaSenha;

          Map corpo = {
            "nome": changeU.nome,
            "email": changeU.email,
            "senha": changeU.senha,
            "dataNas": changeU.dataNas
          };

          var bd = json.encode(corpo);
          // print("Corpo");
          //print(bd);

          String id = changeU.sId;
          // print(id);

          var newUrl = "https://crudcrud.com/api/$hash/usuario/$id";

          var resSenha = await http.put(newUrl, headers: header, body: bd);

          print(resSenha.statusCode);

          if (resSenha.statusCode == 200 || resSenha.statusCode == 201) {
            return senhaId;
          }
        } else {
          //print("user null");
          return null;
        }

        // Alterar a senha

      } else {
        return null;
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  static Future<bool> delete(hash, id) async {
    var url = "https://crudcrud.com/api/$hash/usuario/$id";

    try {
      var response = await http.delete(url);

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
