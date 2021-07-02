import '../models/pagamentos_cr_retorno.dart';

import '../models/contasreceberpagamento.dart';
import '../utils/formatos.dart';
import 'contasreceberpagamento_repository.dart';


class ContasReceberPagamentoListaController {
  final _repository = ContasReceberPagamentoRepository();

  Future<List<ContasReceberPagamento>> listar(int? idAluno, DateTime? dataPagamento) {
    String? dataPagamentoStr = dataPagamento != null ? Formatos.dataYMD.format(dataPagamento) : null;
    return _repository.listar(idAluno, dataPagamentoStr);
  }

  Future<List<PagamentosCrRetorno>> listarPagamentos(int ano, int mes) {
    return _repository.listarPagamentos(ano, mes);
  }  

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}