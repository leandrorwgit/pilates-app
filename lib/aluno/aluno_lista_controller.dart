import '../models/aluno.dart';
import 'aluno_repository.dart';

class AlunoListaController {
  final _repository = AlunoRepository();

  Future<List<Aluno>> listar() {
    return _repository.listar(null, null);
  }

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}
