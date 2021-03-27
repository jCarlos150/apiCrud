import 'package:cadastroAPI/api/usuario.dart';

class UsuariosApi {
  static List<Usuario> getUsuarios() {
    final usuarios = <Usuario>[];

    usuarios.add(Usuario(
        sId: "",
        nome: "teste",
        dataNas: "090909",
        senha: "**",
        email: "email"));
    usuarios.add(Usuario(
        sId: "",
        nome: "teste",
        dataNas: "090909",
        senha: "**",
        email: "email"));
    usuarios.add(Usuario(
        sId: "",
        nome: "teste",
        dataNas: "090909",
        senha: "**",
        email: "email"));
    usuarios.add(Usuario(
        sId: "",
        nome: "teste",
        dataNas: "090909",
        senha: "**",
        email: "email"));

    return usuarios;
  }
}
