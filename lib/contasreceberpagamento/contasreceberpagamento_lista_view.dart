import 'package:app_pilates/utils/formatos.dart';

import '../models/contasreceberpagamento.dart';
import '../models/pagamentos_cr_retorno.dart';
import 'package:flutter/material.dart';
import '../utils/componentes.dart';
import '../utils/estilos.dart';
import '../utils/rotas.dart';
import '../utils/app_colors.dart';
import '../components/app_drawer.dart';
import 'contasreceberpagamento_form_controller.dart';
import 'contasreceberpagamento_lista_controller.dart';

class ContasReceberPagamentoListaView extends StatefulWidget {
  @override
  _ContasReceberPagamentoListaViewState createState() =>
      _ContasReceberPagamentoListaViewState();
}

class _ContasReceberPagamentoListaViewState
    extends State<ContasReceberPagamentoListaView> {
  late ContasReceberPagamentoListaController _controller;
  late ContasReceberPagamentoFormController _controllerForm;
  late Future<List<PagamentosCrRetorno>> _listaPagamentosFuture;
  final filtroAnoController =
      TextEditingController(text: DateTime.now().year.toString());
  String filtroMes = Formatos.getNomeMes(DateTime.now().month.toString());

  @override
  void initState() {
    super.initState();
    _controller = ContasReceberPagamentoListaController();
    _controllerForm = ContasReceberPagamentoFormController();
    carregarListaPagamento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Receb. ' + filtroMes + "/" + filtroAnoController.text),
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
                  // Ano
                  TextField(
                    controller: filtroAnoController,
                    style: TextStyle(color: AppColors.texto),
                    keyboardType: TextInputType.number,
                    decoration: Estilos.getDecoration('Ano'),
                  ),
                  // Mes
                  DropdownButtonFormField<String>(
                    value: filtroMes,
                    items: getListaMeses(Formatos.getMeses()),
                    onChanged: (String? value) {
                      setState(() {
                        filtroMes = value!;
                      });
                    },
                    decoration: Estilos.getDecoration('Mês'),
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
          future: this._listaPagamentosFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<PagamentosCrRetorno>> snapshot) {
            if (snapshot.hasError) {
              return Componentes.erroRest(snapshot);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx, index) {
                        var pagamento = snapshot.data![index];
                        return ListTile(
                          horizontalTitleGap: 10,
                          leading: pagamento.valorPago != null
                              ? Icon(
                                  Icons.check_box,
                                  color: AppColors.darkGreen,
                                )
                              : Icon(
                                  Icons.cancel_rounded,
                                  color: AppColors.darkRed,
                                ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(pagamento.nome!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.texto,
                                    )),
                              ),
                              Text(
                                  Formatos.moedaReal.format(
                                      pagamento.valorPago != null
                                          ? pagamento.valorPago
                                          : pagamento.valorPagamento),
                                  style: TextStyle(
                                    color: AppColors.texto,
                                  )),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: AppColors.delete,
                            ),
                            onPressed: () {
                              _excluirContasReceberPagamento(pagamento);
                            },
                          ),
                          onTap: () {
                            _abrirFormulario(pagamento);
                          },
                        );
                      },
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 10),
                    child: Column(
                      children: [
                        Text(
                            'Total: ' +
                                Formatos.moedaReal.format(snapshot.data!.fold(
                                    0.0,
                                    (double previousValue, element) =>
                                        previousValue +
                                        (element.valorPagamento != null
                                            ? element.valorPagamento!
                                            : 0))),
                            style: TextStyle(
                              color: AppColors.texto,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                            'Total recebido: ' +
                                Formatos.moedaReal.format(snapshot.data!.fold(
                                    0.0,
                                    (double previousValue, element) =>
                                        previousValue +
                                        (element.valorPago != null
                                            ? element.valorPago!
                                            : 0))),
                            style: TextStyle(
                              color: AppColors.texto,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ],
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

  List<DropdownMenuItem<String>> getListaMeses(List meses) {
    List<DropdownMenuItem<String>> items = [];
    for (String mes in meses) {
      items.add(
        DropdownMenuItem(
          value: mes,
          child: Text(mes, style: TextStyle(color: AppColors.texto)),
        ),
      );
    }
    return items;
  }

  void carregarListaPagamento() {
    _listaPagamentosFuture = _controller.listarPagamentos(
        int.parse(filtroAnoController.text),
        int.parse(Formatos.getNumeroMes(filtroMes)));
  }

  void _limparFiltros() {
    filtroAnoController.text = DateTime.now().year.toString();
    filtroMes = Formatos.getNomeMes(DateTime.now().month.toString());
  }

  void _aplicarFiltros() {
    Navigator.of(context).pop();
    setState(() {
      carregarListaPagamento();
    });
  }

  Future<void> _abrirFormulario(PagamentosCrRetorno? pagamento) async {
    ContasReceberPagamento? contasReceberPagamento;
    if (pagamento != null) {
      if (pagamento.idPagamento != null && pagamento.idPagamento! > 0) {
        contasReceberPagamento =
            await _controllerForm.buscarPorId(pagamento.idPagamento!);
      } else if (pagamento.idAluno != null && pagamento.idAluno! > 0) {
        contasReceberPagamento = ContasReceberPagamento();
        contasReceberPagamento.aluno =
            await _controllerForm.buscarAluno(pagamento.idAluno!);
        contasReceberPagamento.valorPago = pagamento.valorPagamento;
      }
    }
    final result = await Navigator.of(context).pushNamed(
        Rotas.CONTASRECEBERPAGAMENTO_FORM,
        arguments: contasReceberPagamento);
    if (result != null) {
      // Se retornou um registro é porque alterou, então atualiza busca
      setState(() {
        carregarListaPagamento();
      });
    }
  }

  void _excluirContasReceberPagamento(PagamentosCrRetorno pagamento) async {
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
                Navigator.of(context)
                    .pop(_controller.excluir(pagamento.idPagamento!));
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
        carregarListaPagamento();
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
