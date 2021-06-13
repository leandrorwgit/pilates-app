import 'dart:convert';

import 'contaspagar.dart';

class ContasPagarPagamento {
  int? id;
  ContasPagar? contasPagar;
  DateTime? dataPagamento;
  double? valorPago;
  String? formaPagamento;

  ContasPagarPagamento(
      {this.id,
      this.contasPagar,
      this.dataPagamento,
      this.valorPago,
      this.formaPagamento});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idContasPagar': contasPagar?.id,
      'dataPagamento': dataPagamento?.toIso8601String(),
      'valorPago': valorPago,
      'formaPagamento': formaPagamento
    };
  }

  factory ContasPagarPagamento.fromMap(Map<String, dynamic> map) {
    return ContasPagarPagamento(
      id: map['id'],
      contasPagar: ContasPagar(id: map['contasPagar']?['id'], descricao: map['contasPagar']?['descricao']),
      dataPagamento: DateTime.parse(map['dataPagamento']),
      valorPago: map['valorPago'],
      formaPagamento: map['formaPagamento'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContasPagarPagamento.fromJson(String source) => ContasPagarPagamento.fromMap(json.decode(source));
}
