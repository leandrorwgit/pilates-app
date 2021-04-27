import 'package:app_pilates/utils/formatos.dart';

import '../models/evolucao.dart';

import '../utils/estilos.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../utils/validacoes.dart';

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
            widget.evolucao == null ? 'Nova Evolução' : 'Alterar Evolução'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: controller.alunoController,
                  style: TextStyle(color: AppColors.texto),
                  keyboardType: TextInputType.text,
                  decoration: Estilos.getDecoration('Aluno'),
                  validator: (String? value) {
                    return Validacoes.validarCampoObrigatorio(
                        value, 'Aluno deve ser informado!');
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: controller.dataController,
                  style: TextStyle(color: AppColors.texto),
                  keyboardType: TextInputType.text,
                  decoration: Estilos.getDecoration(
                    'Data',
                    suffixIcon: IconButton(
                      onPressed: () => _selecionarData(context),
                      icon: Icon(Icons.calendar_today, color: AppColors.label),
                    ),
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
                          style:
                              TextStyle(color: AppColors.label, fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        child: FittedBox(
                          alignment: Alignment.topLeft,
                          fit: BoxFit.scaleDown,
                          child: ToggleButtons(
                            children: controller.aparelhosItens.map<Widget>((aparelho) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(aparelho,
                                    style: TextStyle(color: AppColors.texto)),
                              );
                            }).toList(),
                            fillColor: Theme.of(context).accentColor,
                            isSelected: controller.aparelhosSelecionados,
                            onPressed: (int index) {
                              setState(() {
                                controller.aparelhosSelecionados[index] =
                                    !controller.aparelhosSelecionados[index];
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
                  decoration: Estilos.getDecoration('Orientações domiciliares'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Evolucao evolucao = controller.persistir();
            Navigator.pop(context, evolucao);
          }
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
