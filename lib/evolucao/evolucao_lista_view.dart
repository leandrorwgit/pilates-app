import 'package:app_pilates/utils/componentes.dart';
import 'package:app_pilates/utils/estilos.dart';
import 'package:app_pilates/utils/formatos.dart';
import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../models/evolucao.dart';
import '../utils/rotas.dart';
import '../utils/app_colors.dart';
import 'evolucao_lista_controller.dart';
import '../components/app_drawer.dart';

class EvolucaoListaView extends StatefulWidget {
  @override
  _EvolucaoListaViewState createState() => _EvolucaoListaViewState();
}

class _EvolucaoListaViewState extends State<EvolucaoListaView> {
  late EvolucaoListaController _controller;
  late Future<List<Evolucao>> _listaEvolucaoFuture;
  final filtroNomeController = TextEditingController(text: '');
  final filtroDataController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _controller = EvolucaoListaController();
    _listaEvolucaoFuture = _controller.buscar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evoluções'),
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
                  // Data
                  TextField(
                    readOnly: true,
                    controller: filtroDataController,
                    style: TextStyle(color: AppColors.texto),
                    keyboardType: TextInputType.text,
                    decoration: Estilos.getDecoration(
                      'Data',
                      suffixIcon: IconButton(
                        onPressed: () => _selecionarData(context),
                        icon:
                            Icon(Icons.calendar_today, color: AppColors.label),
                      ),
                    ),
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
          future: this._listaEvolucaoFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Evolucao>> snapshot) {
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
                  var evolucao = snapshot.data![index];
                  return ListTile(
                    title: Text(
                        Formatos.data.format(evolucao.data!) +
                            ' - ' +
                            (evolucao.aluno?.nome ?? ''),
                        style: TextStyle(
                          color: AppColors.texto,
                        )),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: AppColors.delete,
                      ),
                      onPressed: () {
                        _excluirEvolucao(evolucao);
                      },
                    ),
                    onTap: () {
                      _abrirFormulario(evolucao);
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

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    setState(() {
      if (picked != null)
        filtroDataController.text = Formatos.data.format(picked);
      else
        filtroDataController.text = '';
    });
  }

  void _limparFiltros() {
    filtroDataController.text = '';
    filtroNomeController.text = '';
  }

  void _aplicarFiltros() {
    Navigator.of(context).pop();
  }

  Future<void> _abrirFormulario(Evolucao? evolucao) async {
    final result = await Navigator.of(context)
        .pushNamed(Rotas.EVOLUCAO_FORM, arguments: evolucao);
    if (result != null) {
      // Se retornou um registro é porque alterou, então atualiza busca
      setState(() {
        _listaEvolucaoFuture = _controller.buscar();
      });
    }
  }

  void _excluirEvolucao(Evolucao evolucao) async {
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
                Text('Confirmar exlusão do item', style: TextStyle(color: AppColors.texto)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Sim', style: TextStyle(color: AppColors.texto)),
              onPressed: () async {
                Navigator.of(context).pop(_controller.excluir(evolucao.id!));
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
        _listaEvolucaoFuture = _controller.buscar();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
