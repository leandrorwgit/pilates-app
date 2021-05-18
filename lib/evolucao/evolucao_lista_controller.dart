import '../models/evolucao.dart';
import 'evolucao_repository.dart';

class EvolucaoListaController {
  final _repository = EvolucaoRepository();

  Future<List<Evolucao>> buscar() async {
    return _repository.buscar(null, null);
  }

  void dispose() {
    
  }
}