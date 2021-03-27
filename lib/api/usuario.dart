class Usuario {
  String sId;
  String nome;
  String email;
  String senha;
  String dataNas;

  Usuario({this.sId, this.nome, this.email, this.senha, this.dataNas});

  Usuario.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nome = json['nome'];
    email = json['email'];
    senha = json['senha'];
    dataNas = json['dataNas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['dataNas'] = this.dataNas;
    return data;
  }
}
