import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';

import '../models/aluno.dart';

import '../models/contasreceberpagamento.dart';
import '../utils/validacoes.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../utils/formatos.dart';

import '../utils/estilos.dart';

import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'contasreceberpagamento_form_controller.dart';

class ContasReceberPagamentoFormView extends StatefulWidget {
  final ContasReceberPagamento? contasReceberPagamento;

  ContasReceberPagamentoFormView({this.contasReceberPagamento});

  @override
  _ContasReceberPagamentoFormViewState createState() =>
      _ContasReceberPagamentoFormViewState();
}

class _ContasReceberPagamentoFormViewState
    extends State<ContasReceberPagamentoFormView> {
  late final ContasReceberPagamentoFormController controller;

  @override
  void initState() {
    super.initState();
    controller = ContasReceberPagamentoFormController();
    controller.carregar(widget.contasReceberPagamento);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.contasReceberPagamento != null &&
                  widget.contasReceberPagamento!.id != null
              ? 'Alterar Recebimento'
              : 'Novo Recebimento'),
        ),
        body: Stack(children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypeAheadFormField<Aluno>(
                      textFieldConfiguration: TextFieldConfiguration(
                        style: TextStyle(color: AppColors.texto),
                        decoration: Estilos.getDecoration('Aluno'),
                        controller: controller.alunoController,
                      ),
                      suggestionsCallback: (pattern) async {
                        return await controller
                            .listarAlunos(pattern + "%");
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
                        setState(() {
                          controller.alunoValorPagamentoController.text =
                              (suggestion.valorPagamento != null
                                  ? 'Valor: ' +
                                      Formatos.moedaReal
                                          .format(suggestion.valorPagamento)
                                  : '');
                        });
                      },
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Aluno deve ser informado!');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        controller.alunoValorPagamentoController.text,
                        style: TextStyle(color: AppColors.label),
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: controller.dataPagamentoController,
                      onTap: () {
                        _selecionarData(context);
                      },
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration(
                        'Data pagamento',
                        suffixIcon:
                            Icon(Icons.calendar_today, color: AppColors.label),
                      ),
                    ),
                    TextFormField(
                      controller: controller.valorPagoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration('Valor pago'),
                      inputFormatters: [
                        MoneyInputFormatter(
                          thousandSeparator: ThousandSeparator.Period,
                          leadingSymbol: 'R\$',
                          useSymbolPadding: true,
                        )
                      ],
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Valor pago deve ser informado!');
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
                        ContasReceberPagamento contasReceberPagamento =
                            await controller.persistir();
                        Navigator.pop(context, contasReceberPagamento);
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
        controller.dataPagamentoController.text = Formatos.data.format(picked);
      else
        controller.dataPagamentoController.text = '';
    });
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
