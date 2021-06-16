class PagamentosRetorno {
  int? idConta;
  String? descricao;
  double? valor;
  int? idPagamento;
  double? valorPago;

  PagamentosRetorno(
      {this.idConta, this.descricao, this.valor, this.idPagamento, this.valorPago});

  PagamentosRetorno.fromJson(Map<String, dynamic> json) {
    idConta = json['idConta'] != null ? json['idConta'] : null;
    descricao = json['descricao'] ?? '';
    valor = json['valor'] != null ? double.tryParse(json['valor']) ?? 0 : null;
    idPagamento = json['idPagamento'] != null ? json['idPagamento'] : null;
    valorPago = json['valorPago'] != null ? double.tryParse(json['valorPago']) : null;
  }
  
}