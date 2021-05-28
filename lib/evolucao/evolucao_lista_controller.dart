import '../models/evolucao.dart';
import 'evolucao_repository.dart';

class EvolucaoListaController {
  final _repository = EvolucaoRepository();

  Future<List<Evolucao>> listar() {
    return _repository.listar(null, null);
  }

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}