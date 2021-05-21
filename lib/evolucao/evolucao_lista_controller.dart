import '../models/evolucao.dart';
import 'evolucao_repository.dart';

class EvolucaoListaController {
  final _repository = EvolucaoRepository();

  Future<List<Evolucao>> buscar() {
    return _repository.buscar(null, null);
  }

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}