import 'dart:convert';

class Usuario {
  int? id;
  String? nome;
  String? email;
  String? empresa;
  String? cpf;
  bool? ativo;

  Usuario({
      this.id,
      this.nome,
      this.email,
      this.empresa,
      this.cpf,
      this.ativo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'empresa': empresa,
      'cpf': cpf,
      'ativo': ativo,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      empresa: map['empresa'],
      cpf: map['cpf'],
      ativo: map['ativo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) => Usuario.fromMap(json.decode(source));
}
