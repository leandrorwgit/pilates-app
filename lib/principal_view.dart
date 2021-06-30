import 'package:app_pilates/components/app_drawer.dart';
import 'package:flutter/material.dart';

import 'components/grafico_aula_semana.dart';
import 'utils/sessao.dart';

class PrincipalView extends StatefulWidget {
  @override
  _PrincipalView createState() => _PrincipalView();
}

class _PrincipalView extends State<PrincipalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((Sessao.getUsuarioSync().empresa != null
            ? Sessao.getUsuarioSync().empresa!
            : '')),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          // Grafico aulas por dia da semana
          GraficoAulaSemana(),
        ],
      ),
    );
  }
}
