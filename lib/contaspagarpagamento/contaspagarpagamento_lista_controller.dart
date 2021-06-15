import '../models/pagamentos_retorno.dart';

import '../models/contaspagarpagamento.dart';
import '../utils/formatos.dart';
import 'contaspagarpagamento_repository.dart';


class ContasPagarPagamentoListaController {
  final _repository = ContasPagarPagamentoRepository();

  Future<List<ContasPagarPagamento>> listar(int? idContasPagar, DateTime? dataPagamento) {
    String? dataPagamentoStr = dataPagamento != null ? Formatos.dataYMD.format(dataPagamento) : null;
    return _repository.listar(idContasPagar, dataPagamentoStr);
  }

  Future<List<PagamentosRetorno>> listarPagamentos(int ano, int mes) {
    return _repository.listarPagamentos(ano, mes);
  }  

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}