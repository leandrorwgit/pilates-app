import '../agendamento/reagendamento_form_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../models/agenda_retorno.dart';
import '../models/agendamento.dart';
import '../utils/validacoes.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../utils/formatos.dart';
import '../utils/estilos.dart';

import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

class ReAgendamentoFormView extends StatefulWidget {
  final AgendaRetorno? agendaRetorno;

  ReAgendamentoFormView({this.agendaRetorno});

  @override
  _ReAgendamentoFormViewState createState() => _ReAgendamentoFormViewState();
}

class _ReAgendamentoFormViewState extends State<ReAgendamentoFormView> {
  late final ReAgendamentoFormController controller;

  @override
  void initState() {
    super.initState();
    controller = ReAgendamentoFormController();
    controller.carregar(widget.agendaRetorno!);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Reagendamento'),
        ),
        body: Stack(children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      enabled: false,
                      controller: controller.alunoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration('Aluno'),
                    ),                    
                    DateTimeField(
                      format: Formatos.dataHora,
                      controller: controller.dataHoraInicioController,
                      style: TextStyle(color: AppColors.texto),
                      decoration: Estilos.getDecoration('Data/Hora início'),
                      validator: (DateTime? value) {
                        return Validacoes.validarCampoObrigatorio(
                            controller.dataHoraInicioController.text, 'Data/Hora início deve ser informado!');  
                      },                    
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
