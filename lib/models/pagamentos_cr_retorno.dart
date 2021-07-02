class PagamentosCrRetorno {
  int? idAluno;
  String? nome;
  double? valorPagamento;
  int? idPagamento;
  double? valorPago;

  PagamentosCrRetorno(
      {this.idAluno, this.nome, this.valorPagamento, this.idPagamento, this.valorPago});

  PagamentosCrRetorno.fromJson(Map<String, dynamic> json) {
    idAluno = json['idAluno'] != null ? json['idAluno'] : null;
    nome = json['nome'] ?? '';
    valorPagamento = json['valorPagamento'] != null ? double.tryParse(json['valorPagamento']) ?? 0 : null;
    idPagamento = json['idPagamento'] != null ? json['idPagamento'] : null;
    valorPago = json['valorPago'] != null ? double.tryParse(json['valorPago']) : null;
  }
  
}