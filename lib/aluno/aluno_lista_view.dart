import '../utils/estilos.dart';
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
  bool filtroAtivos = true;
  final filtroNomeController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _controller = AlunoListaController();
    carregarListaAluno();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alunos'),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.filter_alt),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      endDrawer: Drawer(
        child: Container(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Filtros',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  // Ativos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Somente ativos',
                        style: TextStyle(color: AppColors.label),
                      ),
                      Switch(
                          value: filtroAtivos,
                          onChanged: (bool value) {
                            setState(() {
                              filtroAtivos = value;
                            });
                          }),
                    ],
                  ),

                  // Nome
                  TextField(
                    controller: filtroNomeController,
                    style: TextStyle(color: AppColors.texto),
                    keyboardType: TextInputType.text,
                    decoration: Estilos.getDecoration('Nome'),
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Limpar Filtros'),
                          onPressed: () => _limparFiltros(),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.darkRed,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Aplicar'),
                          onPressed: () => _aplicarFiltros(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  void carregarListaAluno() {
    _listaAlunosFuture = _controller.listar(
        filtroNomeController.text.isNotEmpty ? filtroNomeController.text+'%' : null, filtroAtivos ? filtroAtivos : null);
  }

  Future<void> _abrirFormulario(Aluno? aluno) async {
    final result = await Navigator.of(context)
        .pushNamed(Rotas.ALUNO_FORM, arguments: aluno);
    if (result != null) {
      // Se retornou um registro é porque alterou, então atualiza busca
      setState(() {
        carregarListaAluno();
      });
    }
  }

  void _excluirAluno(Aluno aluno) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exclusão', style: TextStyle(color: AppColors.label)),
          backgroundColor: AppColors.background,
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Confirmar exlusão do item',
                    style: TextStyle(color: AppColors.texto)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Sim', style: TextStyle(color: AppColors.texto)),
              onPressed: () async {
                Navigator.of(context).pop(_controller.excluir(aluno.id!));
              },
            ),
            TextButton(
              child: Text('Não', style: TextStyle(color: AppColors.label)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    if (result != null) {
      // Se retornou é porque ecluiu, então atualiza busca
      setState(() {
        carregarListaAluno();
      });
    }
  }

  void _limparFiltros() {
    setState(() {
      filtroAtivos = true;
    });
    filtroNomeController.text = '';
  }

  void _aplicarFiltros() {
    Navigator.of(context).pop();
    setState(() {
      carregarListaAluno();
    });
  }

  @override
  void dispose() {
    super.dispose();
    filtroNomeController.dispose();
  }
}
