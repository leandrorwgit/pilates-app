import 'dart:convert';

import 'aluno.dart';

class Evolucao {
  int? id;
  Aluno? aluno;
  DateTime? data;
  String? comoChegou;
  String? condutasUtilizadas;
  String? aparelhosUtilizados;
  String? comoSaiu;
  String? orientacoesDomiciliares;

  Evolucao(
      {this.id,
      this.aluno,
      this.data,
      this.comoChegou,
      this.condutasUtilizadas,
      this.aparelhosUtilizados,
      this.comoSaiu,
      this.orientacoesDomiciliares});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idAluno': aluno?.id,
      'data': data?.toIso8601String(),
      'comoChegou': comoChegou,
      'condutasUtilizadas': condutasUtilizadas,
      'aparelhosUtilizados': aparelhosUtilizados,
      'comoSaiu': comoSaiu,
      'orientacoesDomiciliares': orientacoesDomiciliares,
    };
  }

  factory Evolucao.fromMap(Map<String, dynamic> map) {
    return Evolucao(
      id: map['id'],
      aluno: Aluno(id: map['aluno']?['id'], nome: map['aluno']?['nome']),
      data: DateTime.parse(map['data']),
      comoChegou: map['comoChegou'],
      condutasUtilizadas: map['condutasUtilizadas'],
      aparelhosUtilizados: map['aparelhosUtilizados'],
      comoSaiu: map['comoSaiu'],
      orientacoesDomiciliares: map['orientacoesDomiciliares'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Evolucao.fromJson(String source) => Evolucao.fromMap(json.decode(source));
}
