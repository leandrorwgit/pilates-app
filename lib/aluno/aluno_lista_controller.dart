import '../models/aluno.dart';
import 'aluno_repository.dart';

class AlunoListaController {
  final _repository = AlunoRepository();

  Future<List<Aluno>> listar(String? nome, bool? ativo) {
    return _repository.listar(nome, ativo);
  }

  Future<bool> excluir(int id) {
    return _repository.excluir(id);
  }

  void dispose() {
    
  }
}
