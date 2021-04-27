import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../models/aluno.dart';
import '../utils/rotas.dart';
import '../utils/app_colors.dart';
import 'aluno_lista_controller.dart';
import '../components/app_drawer.dart';

class AlunoListaView extends StatefulWidget {
  @override
  _AlunoListaViewState createState() => _AlunoListaViewState();
}

class _AlunoListaViewState extends State<AlunoListaView> {
  late final controller;

  @override
  void initState() {
    super.initState();
    controller = AlunoListaController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos'),
      ),
      drawer: AppDrawer(),
      body: RxBuilder(builder: (ctx) {
        return ListView.separated(
          padding: EdgeInsets.all(10),
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: controller.alunos.length,
          itemBuilder: (ctx, index) {
            var aluno = controller.alunos[index];
            return ListTile(
              title: Text(aluno.nome,
                  style: TextStyle(
                    color: AppColors.texto,
                  )),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: AppColors.delete,
                ),
                onPressed: () {
                  _excluirAluno(aluno);
                },
              ),
              onTap: () {
                _abrirFormulario(aluno);
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _abrirFormulario(null);
        },
      ),
    );
  }

  Future<void> _abrirFormulario(Aluno? aluno) async {
    final result = await Navigator.of(context)
        .pushNamed(Rotas.ALUNO_FORM, arguments: aluno);
    controller.alunos.add(result);
  }

  void _excluirAluno(Aluno aluno) {
    controller.alunos.remove(aluno);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
