import '../models/aluno.dart';
import 'aluno_repository.dart';

class AlunoListaController {
  final _repository = AlunoRepository();

  Future<List<Aluno>> buscar() {
    return _repository.buscar(null, null);
  }

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}
