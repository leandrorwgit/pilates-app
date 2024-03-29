import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../utils/estilos.dart';

import '../utils/validacoes.dart';

import '../models/aluno.dart';
import 'aluno_form_controller.dart';
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

class AlunoFormView extends StatefulWidget {
  final Aluno? aluno;

  AlunoFormView({this.aluno});

  @override
  _AlunoFormViewState createState() => _AlunoFormViewState();
}

class _AlunoFormViewState extends State<AlunoFormView> {
  final _formKey = GlobalKey<FormState>();
  late final AlunoFormController controller;
  TimeOfDay horaSelecionada = TimeOfDay(hour: 07, minute: 00);

  @override
  void initState() {
    super.initState();
    controller = AlunoFormController();
    controller.carregar(widget.aluno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.aluno == null ? 'Novo Paciente' : 'Alterar Paciente'),
        ),
        body: Stack(children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Ativo',
                          style: TextStyle(color: AppColors.label),
                        ),
                        Switch(
                            value: controller.ativo,
                            onChanged: (bool value) {
                              setState(() {
                                controller.ativo = value;
                              });
                            }),
                      ],
                    ),
                    TextFormField(
                      controller: controller.nomeController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Nome'),
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Nome deve ser informado!');
                      },
                    ),
                    TextFormField(
                      controller: controller.idadeController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration('Idade'),
                    ),
                    TextFormField(
                      controller: controller.dataNascimentoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration(
                          'Data Nascimento [Ex: 10/06/1986]'),
                      inputFormatters: [MaskedInputFormatter("00/00/0000")],
                      validator: (String? value) {
                        return Validacoes.validarData(
                            value, "Data de nascimento inválida!");
                      },
                    ),
                    TextFormField(
                      controller: controller.profissaoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Profissão'),
                    ),
                    TextFormField(
                      controller: controller.celularController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration(
                          'Celular [Ex: (47) 91234-5678]'),
                      inputFormatters: [
                        MaskedInputFormatter("(00) 00000-0000")
                      ],
                    ),
                    TextFormField(
                      controller: controller.emailController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.emailAddress,
                      decoration: Estilos.getDecoration('Email'),
                    ),
                    TextFormField(
                      controller: controller.objetivosPilatesController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Objetivo Pilates'),
                      maxLines: 2,
                    ),
                    TextFormField(
                      controller: controller.queixasController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Queixas'),
                    ),
                    // Aula
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Aula',
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
                                children: [
                                  Text('SEG'+(controller.aulaHorarioInicioDiaSelecionado[0] != null ? '\n'+controller.aulaHorarioInicioDiaSelecionado[0]! : ''),
                                      style: TextStyle(color: AppColors.texto),
                                      textAlign: TextAlign.center),
                                  Text('TER'+(controller.aulaHorarioInicioDiaSelecionado[1] != null ? '\n'+controller.aulaHorarioInicioDiaSelecionado[1]! : ''),
                                      style: TextStyle(color: AppColors.texto),
                                      textAlign: TextAlign.center),
                                  Text('QUA'+(controller.aulaHorarioInicioDiaSelecionado[2] != null ? '\n'+controller.aulaHorarioInicioDiaSelecionado[2]! : ''),
                                      style: TextStyle(color: AppColors.texto),
                                      textAlign: TextAlign.center),
                                  Text('QUI'+(controller.aulaHorarioInicioDiaSelecionado[3] != null ? '\n'+controller.aulaHorarioInicioDiaSelecionado[3]! : ''),
                                      style: TextStyle(color: AppColors.texto),
                                      textAlign: TextAlign.center),
                                  Text('SEX'+(controller.aulaHorarioInicioDiaSelecionado[4] != null ? '\n'+controller.aulaHorarioInicioDiaSelecionado[4]! : ''),
                                      style: TextStyle(color: AppColors.texto),
                                      textAlign: TextAlign.center),
                                  Text('SAB'+(controller.aulaHorarioInicioDiaSelecionado[5] != null ? '\n'+controller.aulaHorarioInicioDiaSelecionado[5]! : ''),
                                      style: TextStyle(color: AppColors.texto),
                                      textAlign: TextAlign.center),
                                ],
                                fillColor: Theme.of(context).accentColor,
                                isSelected: controller.aulaDiaSelecionado,
                                onPressed: (int index) {
                                  setState(() {
                                    controller.aulaDiaSelecionado[index] =
                                        !controller.aulaDiaSelecionado[index];
                                    if (controller.aulaDiaSelecionado[index])
                                      _selecionarHora(context, index);
                                    else
                                      controller.aulaHorarioInicioDiaSelecionado[index] = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: controller.aulaDuracaoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration(
                          'Duração da aula (minutos) [Ex: 45]'),
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Duração da aula deve ser informada!');
                      },
                    ),
                    // Forma Pagamento
                    DropdownButtonFormField<String>(
                      value: controller.formaPagamento,
                      items: getListaFormaPagamento(
                          controller.formaPagamentoItens),
                      onChanged: (String? value) {
                        setState(() {
                          controller.formaPagamento = value!;
                        });
                      },
                      decoration: Estilos.getDecoration('Forma Pagamento'),
                    ),
                    // Dia Pagamento
                    TextFormField(
                      controller: controller.diaPagamentoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration('Dia Pagamento'),
                    ),
                    TextFormField(
                      controller: controller.valorPagamentoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration('Valor Pagamento'),
                      inputFormatters: [
                        MoneyInputFormatter(
                          thousandSeparator: ThousandSeparator.Period,
                          leadingSymbol: 'R\$',
                          useSymbolPadding: true,
                        )
                      ],
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Valor do pagamento deve ser informado!');
                      },
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
                        Aluno aluno = await controller.persistir();
                        Navigator.pop(context, aluno);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
          );
        }));
  }

  List<DropdownMenuItem<String>> getListaFormaPagamento(List formas) {
    List<DropdownMenuItem<String>> items = [];
    for (String forma in formas) {
      items.add(
        DropdownMenuItem(
          value: forma,
          child: Text(forma, style: TextStyle(color: AppColors.texto)),
        ),
      );
    }
    return items;
  }

  Future<void> _selecionarHora(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: horaSelecionada,
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
    if (picked != null) {
      setState(() {
        horaSelecionada = picked;
        controller.aulaHorarioInicioDiaSelecionado[index] =
            horaSelecionada.format(context).split(" ")[0];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
