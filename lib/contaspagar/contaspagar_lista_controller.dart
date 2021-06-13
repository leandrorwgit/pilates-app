import '../models/contaspagar.dart';

import 'contaspagar_repository.dart';

class ContasPagarListaController {
  final _repository = ContasPagarRepository();

  Future<List<ContasPagar>> listar(String? descricao, bool? ativo) {
    return _repository.listar(descricao, ativo);
  }

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}
