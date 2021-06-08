import 'package:app_pilates/models/aluno.dart';
import 'package:app_pilates/utils/validacoes.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../utils/formatos.dart';
import '../models/evolucao.dart';

import '../utils/estilos.dart';

import 'evolucao_form_controller.dart';
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

class EvolucaoFormView extends StatefulWidget {
  final Evolucao? evolucao;

  EvolucaoFormView({this.evolucao});

  @override
  _EvolucaoFormViewState createState() => _EvolucaoFormViewState();
}

class _EvolucaoFormViewState extends State<EvolucaoFormView> {
  late final controller;

  @override
  void initState() {
    super.initState();
    controller = EvolucaoFormController();
    controller.carregar(widget.evolucao);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.evolucao != null && widget.evolucao!.id != null ? 'Alterar Evolução' : 'Nova Evolução'),
        ),
        body: Stack(children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TypeAheadFormField<Aluno>(
                      textFieldConfiguration: TextFieldConfiguration(
                        style: TextStyle(color: AppColors.texto),
                        decoration: Estilos.getDecoration('Aluno'),
                        controller: controller.alunoController,
                      ),
                      suggestionsCallback: (pattern) async {
                        return await controller.buscarAlunos(pattern + "%");
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
                        controller.alunoSelecionado = suggestion;
                        controller.alunoController.text = suggestion.nome;
                      },
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Aluno deve ser informado!');
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: controller.dataController,
                      onTap: () {
                        _selecionarData(context);
                      },
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration(
                        'Data',
                        suffixIcon: Icon(Icons.calendar_today, color: AppColors.label),
                      ),
                    ),
                    TextFormField(
                      controller: controller.comoChegouController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Como chegou'),
                    ),
                    TextFormField(
                      controller: controller.condutasUtilizadasController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Condutas utilizadas'),
                      maxLines: 4,
                    ),

                    // Aparelhos utilizados
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Aparelhos utilizados',
                              style: TextStyle(
                                  color: AppColors.label, fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            child: FittedBox(
                              alignment: Alignment.topLeft,
                              fit: BoxFit.scaleDown,
                              child: ToggleButtons(
                                children: controller.aparelhosItens
                                    .map<Widget>((aparelho) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(aparelho,
                                        style:
                                            TextStyle(color: AppColors.texto)),
                                  );
                                }).toList(),
                                fillColor: Theme.of(context).accentColor,
                                isSelected: controller.aparelhosSelecionados,
                                onPressed: (int index) {
                                  setState(() {
                                    controller.aparelhosSelecionados[index] =
                                        !controller
                                            .aparelhosSelecionados[index];
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: controller.comoSaiuController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Como saiu'),
                    ),
                    TextFormField(
                      controller: controller.orientacoesDomiciliaresController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration:
                          Estilos.getDecoration('Orientações domiciliares'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loading
          Positioned(
            child: RxBuilder(builder: (_) {
              return controller.carregando.value
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                      color: Colors.white.withOpacity(0.1),
                    )
                  : Container();
            }),
          )
        ]),
        floatingActionButton: RxBuilder(builder: (_) {
          return FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: controller.carregando.value
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        Evolucao evolucao = await controller.persistir();
                        Navigator.pop(context, evolucao);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
          );
        }));
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      if (picked != null)
        controller.dataController.text = Formatos.data.format(picked);
      else
        controller.dataController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
