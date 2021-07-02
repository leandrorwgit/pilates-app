import 'dart:convert';

import 'aluno.dart';

class ContasReceberPagamento {
  int? id;
  Aluno? aluno;
  DateTime? dataPagamento;
  double? valorPago;
  String? formaPagamento;

  ContasReceberPagamento(
      {this.id,
      this.aluno,
      this.dataPagamento,
      this.valorPago,
      this.formaPagamento});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idAluno': aluno?.id,
      'dataPagamento': dataPagamento?.toIso8601String(),
      'valorPago': valorPago != null ? valorPago!.toStringAsFixed(2) : null,
      'formaPagamento': formaPagamento
    };
  }

  factory ContasReceberPagamento.fromMap(Map<String, dynamic> map) {
    return ContasReceberPagamento(
      id: map['id'],
      aluno: Aluno(id: map['aluno']?['id'], nome: map['aluno']?['nome'], valorPagamento: double.tryParse(map['aluno']?['valorPagamento']) ?? 0),
      dataPagamento: DateTime.parse(map['dataPagamento']),
      valorPago: double.tryParse(map['valorPago']) ?? 0,
      formaPagamento: map['formaPagamento'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContasReceberPagamento.fromJson(String source) => ContasReceberPagamento.fromMap(json.decode(source));
}
