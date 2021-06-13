import 'dart:convert';

class ContasPagar {
  int? id;
  String? descricao;
  int? diaVencimento;
  double? valor;
  String? formaPagamento; // Pix/Dinheiro/Deposito/DOC
  bool? ativo;

  ContasPagar({
      this.id,
      this.descricao,
      this.diaVencimento,
      this.valor,
      this.formaPagamento,
      this.ativo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'diaVencimento': diaVencimento,
      'valor': valor != null ? valor!.toStringAsFixed(2) : null,
      'formaPagamento': formaPagamento,
      'ativo': ativo,
    };
  }

  factory ContasPagar.fromMap(Map<String, dynamic> map) {
    return ContasPagar(
      id: map['id'],
      descricao: map['descricao'],
      diaVencimento: map['diaVencimento'],
      valor: double.tryParse(map['valor']) ?? 0,
      formaPagamento: map['formaPagamento'],
      ativo: map['ativo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContasPagar.fromJson(String source) => ContasPagar.fromMap(json.decode(source));
}
