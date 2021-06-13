import 'package:app_pilates/models/contaspagar.dart';

import '../utils/estilos.dart';
import 'package:flutter/material.dart';

import '../utils/componentes.dart';
import '../utils/rotas.dart';
import '../utils/app_colors.dart';
import '../components/app_drawer.dart';
import 'contaspagar_lista_controller.dart';

class ContasPagarListaView extends StatefulWidget {
  @override
  _ContasPagarListaViewState createState() => _ContasPagarListaViewState();
}

class _ContasPagarListaViewState extends State<ContasPagarListaView> {
  late ContasPagarListaController _controller;
  late Future<List<ContasPagar>> _listaContasPagarFuture;
  bool filtroAtivos = true;
  final filtroDescricaoController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _controller = ContasPagarListaController();
    carregarListaContasPagar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contas a Pagar'),
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
                    controller: filtroDescricaoController,
                    style: TextStyle(color: AppColors.texto),
                    keyboardType: TextInputType.text,
                    decoration: Estilos.getDecoration('Descrição'),
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
          future: this._listaContasPagarFuture,
          builder: (BuildContext context, AsyncSnapshot<List<ContasPagar>> snapshot) {
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
                  var contasPagar = snapshot.data![index];
                  return ListTile(
                    title: Text(contasPagar.descricao!,
                        style: TextStyle(
                          color: AppColors.texto,
                        )),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: AppColors.delete,
                      ),
                      onPressed: () {
                        _excluirConta(contasPagar);
                      },
                    ),
                    onTap: () {
                      _abrirFormulario(contasPagar);
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

  void carregarListaContasPagar() {
    _listaContasPagarFuture = _controller.listar(
        filtroDescricaoController.text.isNotEmpty ? filtroDescricaoController.text+'%' : null, filtroAtivos ? filtroAtivos : null);
  }

  Future<void> _abrirFormulario(ContasPagar? contasPagar) async {
    final result = await Navigator.of(context)
        .pushNamed(Rotas.CONTASPAGAR_FORM, arguments: contasPagar);
    if (result != null) {
      // Se retornou um registro é porque alterou, então atualiza busca
      setState(() {
        carregarListaContasPagar();
      });
    }
  }

  void _excluirConta(ContasPagar contasPagar) async {
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
                Navigator.of(context).pop(_controller.excluir(contasPagar.id!));
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
        carregarListaContasPagar();
      });
    }
  }

  void _limparFiltros() {
    setState(() {
      filtroAtivos = true;
    });
    filtroDescricaoController.text = '';
  }

  void _aplicarFiltros() {
    Navigator.of(context).pop();
    setState(() {
      carregarListaContasPagar();
    });
  }

  @override
  void dispose() {
    super.dispose();
    filtroDescricaoController.dispose();
  }
}
