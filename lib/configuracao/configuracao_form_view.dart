import 'package:app_pilates/components/app_drawer.dart';
import 'package:app_pilates/utils/componentes.dart';

import '../utils/sessao.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../utils/estilos.dart';

import '../utils/validacoes.dart';

import '../models/configuracao.dart';
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'configuracao_form_controller.dart';

class ConfiguracaoFormView extends StatefulWidget {
  @override
  _ConfiguracaoFormViewState createState() => _ConfiguracaoFormViewState();
}

class _ConfiguracaoFormViewState extends State<ConfiguracaoFormView> {
  final _formKey = GlobalKey<FormState>();
  late final ConfiguracaoFormController controller;
  late Future<Configuracao?> _configuracaoFuture;

  @override
  void initState() {
    super.initState();
    controller = ConfiguracaoFormController();
    _configuracaoFuture = Sessao.getConfiguracaoAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Configurações'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: this._configuracaoFuture,
            builder:
                (BuildContext context, AsyncSnapshot<Configuracao?> snapshot) {
                  print(snapshot);
              if (snapshot.hasError) {
                return Componentes.erroRest(snapshot);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData)
                  controller.carregar(snapshot.data);
                return Stack(children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller:
                                  controller.duracaoPadraoAulaController,
                              style: TextStyle(color: AppColors.texto),
                              keyboardType: TextInputType.number,
                              decoration: Estilos.getDecoration(
                                  'Duração padrão da aula (minutos) [Ex: 45]'),
                              validator: (String? value) {
                                return Validacoes.validarCampoObrigatorio(value,
                                    'Duração da aula deve ser informada!');
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
                ]);
              }
            }),
        floatingActionButton: RxBuilder(builder: (_) {
          return FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: controller.carregando.value
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        Configuracao configuracao =
                            await controller.persistir();
                        Sessao.atualizaConfiguracao(configuracao);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Configuração salva.')));
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
