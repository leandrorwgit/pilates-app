import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';

import '../models/contaspagar.dart';

import '../models/contaspagarpagamento.dart';
import '../utils/validacoes.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../utils/formatos.dart';
import '../models/evolucao.dart';

import '../utils/estilos.dart';

import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'contaspagarpagamento_form_controller.dart';

class ContasPagarPagamentoFormView extends StatefulWidget {
  final ContasPagarPagamento? contasPagarPagamento;

  ContasPagarPagamentoFormView({this.contasPagarPagamento});

  @override
  _ContasPagarPagamentoFormViewState createState() =>
      _ContasPagarPagamentoFormViewState();
}

class _ContasPagarPagamentoFormViewState
    extends State<ContasPagarPagamentoFormView> {
  late final ContasPagarPagamentoFormController controller;

  @override
  void initState() {
    super.initState();
    controller = ContasPagarPagamentoFormController();
    controller.carregar(widget.contasPagarPagamento);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.contasPagarPagamento != null &&
                  widget.contasPagarPagamento!.id != null
              ? 'Alterar Pagamento'
              : 'Novo Pagamento'),
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
                    TypeAheadFormField<ContasPagar>(
                      textFieldConfiguration: TextFieldConfiguration(
                        style: TextStyle(color: AppColors.texto),
                        decoration: Estilos.getDecoration('Conta'),
                        controller: controller.contasPagarController,
                      ),
                      suggestionsCallback: (pattern) async {
                        return await controller
                            .listarContasPagar(pattern + "%");
                      },
                      itemBuilder: (context, ContasPagar suggestion) {
                        return ListTile(
                          title: Text(suggestion.descricao!,
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
                      onSuggestionSelected: (ContasPagar suggestion) {
                        controller.contasPagarSelecionada = suggestion;
                        controller.contasPagarController.text =
                            suggestion.descricao!;
                        setState(() {
                          controller.contasPagarValorController.text =
                              (suggestion.valor != null
                                  ? 'Valor: ' +
                                      Formatos.moedaReal
                                          .format(suggestion.valor)
                                  : '');
                        });
                      },
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Conta deve ser informada!');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        controller.contasPagarValorController.text,
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
                        ContasPagarPagamento contasPagarPagamento =
                            await controller.persistir();
                        Navigator.pop(context, contasPagarPagamento);
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
