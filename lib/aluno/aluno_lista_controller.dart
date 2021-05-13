import '../models/aluno.dart';
import 'aluno_repository.dart';

class AlunoListaController {
  final _repository = AlunoRepository();

  Future<List<Aluno>> buscar() async {
    return _repository.buscar(null, null);
  }

  void dispose() {
    
  }
}
