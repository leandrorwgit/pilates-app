import 'package:app_pilates/models/agendamento.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../models/aluno.dart';
import '../utils/validacoes.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../utils/formatos.dart';
import '../models/agendamento.dart';

import '../utils/estilos.dart';

import '../agendamento/agendamento_form_controller.dart';
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

class AgendamentoFormView extends StatefulWidget {
  final Agendamento? agendamento;

  AgendamentoFormView({this.agendamento});

  @override
  _AgendamentoFormViewState createState() => _AgendamentoFormViewState();
}

class _AgendamentoFormViewState extends State<AgendamentoFormView> {
  late final AgendamentoFormController controller;

  @override
  void initState() {
    super.initState();
    controller = AgendamentoFormController();
    controller.carregar(widget.agendamento);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.agendamento != null && widget.agendamento!.id != null
                  ? 'Alterar Agendamento'
                  : 'Novo Agendamento'),
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
                        controller.alunoController.text = suggestion.nome!;
                      },
                    ),
                    DateTimePicker(
                      initialValue: DateTime.now().toString(),
                      type: DateTimePickerType.dateTime,
                      dateMask: 'dd/MM/yyyy HH:mm',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      style: TextStyle(color: AppColors.texto),
                      decoration: Estilos.getDecoration('Data/Hora início'),
                      timeLabelText: '',
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Data/Hora início deve ser informado!');
                      },
                      onChanged: (val) =>
                          controller.dataHoraInicioController.text = val,
                    ),
                    TextFormField(
                      controller: controller.duracaoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration:
                          Estilos.getDecoration('Duração (minutos) [Ex: 45]'),
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Duração deve ser informado!');
                      },
                    ),
                    TextFormField(
                      controller: controller.tituloController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Título'),
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Título deve ser informado!');
                      },
                    ),
                    TextFormField(
                      controller: controller.descricaoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Descrição'),
                    ),
                    // Situacao
                    DropdownButtonFormField<String>(
                      value: controller.situacao,
                      items: getListaSituacao(controller.situacaoItens),
                      onChanged: (String? value) {
                        setState(() {
                          controller.situacao = value!;
                        });
                      },
                      decoration: Estilos.getDecoration('Situação'),
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
                        Agendamento agendamento = await controller.persistir();
                        Navigator.pop(context, agendamento);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
          );
        }));
  }

  List<DropdownMenuItem<String>> getListaSituacao(List situacoes) {
    List<DropdownMenuItem<String>> items = [];
    for (String situacao in situacoes) {
      items.add(
        DropdownMenuItem(
          value: situacao,
          child: Text(situacao, style: TextStyle(color: AppColors.texto)),
        ),
      );
    }
    return items;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
