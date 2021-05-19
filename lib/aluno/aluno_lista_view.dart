import 'package:flutter/material.dart';

import '../aluno/aluno_lista_controller.dart';
import '../utils/componentes.dart';
import '../models/aluno.dart';
import '../utils/rotas.dart';
import '../utils/app_colors.dart';
import '../components/app_drawer.dart';

class AlunoListaView extends StatefulWidget {
  @override
  _AlunoListaViewState createState() => _AlunoListaViewState();
}

class _AlunoListaViewState extends State<AlunoListaView> {
  late AlunoListaController _controller;
  late Future<List<Aluno>> _listaAlunosFuture;

  @override
  void initState() {
    super.initState();
    _controller = AlunoListaController();
    _listaAlunosFuture = _controller.buscar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: this._listaAlunosFuture,
          builder: (BuildContext context, AsyncSnapshot<List<Aluno>> snapshot) {
            if (snapshot.hasError) {
              return Componentes.erroRest(snapshot);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                padding: EdgeInsets.all(10),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  var aluno = snapshot.data![index];
                  return ListTile(
                    title: Text(aluno.nome!,
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
            }
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
    if (result != null) {
      // Se retornou um registro é porque alterou, então atualiza busca
      setState(() {
        _listaAlunosFuture = _controller.buscar();
      });
    }
  }

  void _excluirAluno(Aluno aluno) {
    //controller.alunos.remove(aluno);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
