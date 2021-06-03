import 'package:app_pilates/models/aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../utils/componentes.dart';
import '../utils/estilos.dart';
import '../utils/formatos.dart';
import '../models/evolucao.dart';
import '../utils/rotas.dart';
import '../utils/app_colors.dart';
import 'evolucao_form_controller.dart';
import 'evolucao_lista_controller.dart';
import '../components/app_drawer.dart';

class EvolucaoListaView extends StatefulWidget {
  @override
  _EvolucaoListaViewState createState() => _EvolucaoListaViewState();
}

class _EvolucaoListaViewState extends State<EvolucaoListaView> {
  late EvolucaoListaController _controller;
  late EvolucaoFormController _controllerForm;
  late Future<List<Evolucao>> _listaEvolucaoFuture;
  DateTime? filtroDataSelecionada = DateTime.now();
  Aluno? filtroAlunoSelecionado;
  final filtroAlunoController = TextEditingController(text: '');
  final filtroDataController =
      TextEditingController(text: Formatos.data.format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    _controller = EvolucaoListaController();
    _controllerForm = EvolucaoFormController();
    carregarListaEvolucao();
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
                    onTap: () {
                      _selecionarData(context);
                    },
                    keyboardType: TextInputType.text,
                    decoration: Estilos.getDecoration(
                      'Data',
                      suffixIcon:
                          Icon(Icons.calendar_today, color: AppColors.label),
                    ),
                  ),
                  // Aluno
                  TypeAheadField<Aluno>(
                    textFieldConfiguration: TextFieldConfiguration(
                      style: TextStyle(color: AppColors.texto),
                      decoration: Estilos.getDecoration('Aluno'),
                      controller: filtroAlunoController,
                    ),
                    suggestionsCallback: (pattern) async {
                      return await _controllerForm.buscarAlunos(pattern + "%");
                    },
                    itemBuilder: (context, Aluno suggestion) {
                      return ListTile(
                        title: Text(suggestion.nome!,
                            style: TextStyle(color: AppColors.texto)),
                      );
                    },
                    noItemsFoundBuilder: (_) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Nenhum aluno encontrado!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.label),
                        ),
                      );
                    },
                    onSuggestionSelected: (Aluno suggestion) {
                      filtroAlunoSelecionado = suggestion;
                      filtroAlunoController.text = suggestion.nome!;
                    },
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

  void carregarListaEvolucao() {
    _listaEvolucaoFuture =
        _controller.listar(filtroAlunoSelecionado?.id, filtroDataSelecionada);
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: filtroDataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.texto,
              onSurface: AppColors.label,
            ),
          ),
          child: child!,
        );
      },
    );
    setState(() {
      if (picked != null) {
        filtroDataSelecionada = picked;
        filtroDataController.text =
            Formatos.data.format(filtroDataSelecionada!);
      } else {
        filtroDataSelecionada = null;
        filtroDataController.text = '';
      }
    });
  }

  void _limparFiltros() {
    filtroDataSelecionada = null;
    filtroDataController.text = '';
    filtroAlunoSelecionado = null;
    filtroAlunoController.text = '';
  }

  void _aplicarFiltros() {
    Navigator.of(context).pop();
    setState(() {
      carregarListaEvolucao();
    });
  }

  Future<void> _abrirFormulario(Evolucao? evolucao) async {
    final result = await Navigator.of(context)
        .pushNamed(Rotas.EVOLUCAO_FORM, arguments: evolucao);
    if (result != null) {
      // Se retornou um registro é porque alterou, então atualiza busca
      setState(() {
        carregarListaEvolucao();
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
                Text('Confirmar exlusão do item',
                    style: TextStyle(color: AppColors.texto)),
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
        carregarListaEvolucao();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controllerForm.dispose();
  }
}
