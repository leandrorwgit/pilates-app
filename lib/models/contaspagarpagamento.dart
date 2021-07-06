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
      'valorPago': valorPago != null ? valorPago!.toStringAsFixed(2) : null,
      'formaPagamento': formaPagamento
    };
  }

  factory ContasPagarPagamento.fromMap(Map<String, dynamic> map) {
    return ContasPagarPagamento(
      id: map['id'],
      contasPagar: map['contasPagar'] != null ? ContasPagar(id: map['contasPagar']?['id'], descricao: map['contasPagar']?['descricao'], valor: double.tryParse(map['contasPagar']?['valor']) ?? 0) : null,
      dataPagamento: DateTime.parse(map['dataPagamento']),
      valorPago: double.tryParse(map['valorPago']) ?? 0,
      formaPagamento: map['formaPagamento'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContasPagarPagamento.fromJson(String source) => ContasPagarPagamento.fromMap(json.decode(source));
}
