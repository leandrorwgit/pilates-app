import '../utils/formatos.dart';

import '../models/evolucao.dart';
import '../evolucao/evolucao_repository.dart';
import '../agendamento/agendamento_repository.dart';

class AgendamentoListaController {
  final _repository = EvolucaoRepository();

  Future<List<Evolucao>> listar(int? idAluno, DateTime? data) {
    String? dataStr = data != null ? Formatos.dataYMD.format(data) : null;
    return _repository.listar(idAluno, dataStr);
  }

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}