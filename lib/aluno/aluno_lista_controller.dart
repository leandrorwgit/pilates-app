import 'package:rx_notifier/rx_notifier.dart';

import '../models/aluno.dart';

class AlunoListaController {
  final alunos = RxList<Aluno>([Aluno.getTeste()]);
  final carregando = false;

  void dispose() {
    alunos.clear();
  }
}
