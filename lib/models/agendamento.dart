import 'dart:convert';

import 'aluno.dart';

class Agendamento {
  int? id;
  Aluno? aluno;
  DateTime? dataHoraInicio;
  int? duracao;
  String? titulo;
  String? descricao;
  String? situacao; // CRIADO, CANCELADO, CONCLUIDO  

  Agendamento({
    this.id,
    this.aluno,
    this.dataHoraInicio,
    this.duracao,
    this.titulo,
    this.descricao,
    this.situacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idAluno': aluno?.id,
      'dataHoraInicio': dataHoraInicio?.toIso8601String(),
      'duracao': duracao,
      'titulo': titulo,
      'descricao': descricao,
      'situacao': situacao,
    };
  }

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'],
      aluno: Aluno(id: map['aluno']?['id'], nome: map['aluno']?['nome']),
      dataHoraInicio: DateTime.parse(map['dataHoraInicio']),
      duracao: map['duracao'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      situacao: map['situacao'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Agendamento.fromJson(String source) => Agendamento.fromMap(json.decode(source));
}
