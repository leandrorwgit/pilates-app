import 'package:app_pilates/models/contaspagar.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../utils/estilos.dart';

import '../utils/validacoes.dart';

import 'contaspagar_form_controller.dart';
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

class ContasPagarFormView extends StatefulWidget {
  final ContasPagar? contasPagar;

  ContasPagarFormView({this.contasPagar});

  @override
  _ContasPagarFormViewState createState() => _ContasPagarFormViewState();
}

class _ContasPagarFormViewState extends State<ContasPagarFormView> {
  final _formKey = GlobalKey<FormState>();
  late final ContasPagarFormController controller;
  TimeOfDay horaSelecionada = TimeOfDay(hour: 07, minute: 00);

  @override
  void initState() {
    super.initState();
    controller = ContasPagarFormController();
    controller.carregar(widget.contasPagar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.contasPagar == null ? 'Nova Conta' : 'Alterar Conta'),
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
                      controller: controller.descricaoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.text,
                      decoration: Estilos.getDecoration('Descrição'),
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Descrição deve ser informada!');
                      },
                    ),
                    TextFormField(
                      controller: controller.diaVencimentoController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration('Dia vencimento'),
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Dia vencimento deve ser informado!');
                      },
                    ),
                    TextFormField(
                      controller: controller.valorController,
                      style: TextStyle(color: AppColors.texto),
                      keyboardType: TextInputType.number,
                      decoration: Estilos.getDecoration('Valor'),
                      inputFormatters: [
                        MoneyInputFormatter(
                          thousandSeparator: ThousandSeparator.Period,
                          leadingSymbol: 'R\$',
                          useSymbolPadding: true,
                        )
                      ],
                      validator: (String? value) {
                        return Validacoes.validarCampoObrigatorio(
                            value, 'Valor deve ser informado!');
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
                        ContasPagar contasPagar = await controller.persistir();
                        Navigator.pop(context, contasPagar);
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
