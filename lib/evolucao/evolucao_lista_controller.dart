import 'package:rx_notifier/rx_notifier.dart';

import '../models/evolucao.dart';

class EvolucaoListaController {
  final evolucoes = RxList<Evolucao>([Evolucao.getTeste()]);
  final carregando = false;

  void dispose() {
    evolucoes.clear();
  }
}