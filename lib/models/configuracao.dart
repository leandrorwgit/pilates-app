import 'dart:convert';

class Configuracao {
  int? id;
  int? duracaoPadraoAula;

  Configuracao({
      this.id,
      this.duracaoPadraoAula});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'duracaoPadraoAula': duracaoPadraoAula
    };
  }

  factory Configuracao.fromMap(Map<String, dynamic> map) {
    return Configuracao(
      id: map['id'],
      duracaoPadraoAula: map['duracaoPadraoAula']
    );
  }

  String toJson() => json.encode(toMap());

  factory Configuracao.fromJson(String source) => Configuracao.fromMap(json.decode(source));
}
