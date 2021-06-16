import '../models/pagamentos_retorno.dart';
import '../models/contaspagarpagamento.dart';
import '../utils/custom_dio.dart';

class ContasPagarPagamentoRepository {

  Future<ContasPagarPagamento> inserir(ContasPagarPagamento pagamento) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('contaspagarpagamento', data: pagamento.toJson());
    return ContasPagarPagamento.fromMap(res.data);    
  }

  Future<ContasPagarPagamento> atualizar(ContasPagarPagamento pagamento) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.put('contaspagarpagamento/'+pagamento.id.toString(), data: pagamento.toJson());

    return ContasPagarPagamento.fromMap(res.data);    
  }  

  Future<bool> excluir(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.delete('contaspagarpagamento/'+id.toString());
    return res.statusCode != null && res.statusCode == 204;
  }

  Future<ContasPagarPagamento> buscar(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('contaspagarpagamento/'+id.toString());
    if (res.data != null) {
      return ContasPagarPagamento.fromMap(res.data);
    } else {
      return ContasPagarPagamento();
    }
  }   

  Future<List<ContasPagarPagamento>> listar(int? idContasPagar, String? data) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (idContasPagar != null)
      params['idContasPagar'] = idContasPagar;
    if (data != null)
      params['data'] = data;

    var res = await dio.get('contaspagarpagamento', queryParameters: params);
    if (res.data != null) {
      return res.data.map<ContasPagarPagamento>((c) => ContasPagarPagamento.fromMap(c)).toList() as List<ContasPagarPagamento>;
    } else {
      return [];
    }
  }

  Future<List<PagamentosRetorno>> listarPagamentos(int ano, int mes) async {
    var dio = CustomDio.comAutenticacao().instancia;
    print(mes);
    var res = await dio.get('contaspagarpagamento/pagamentos', queryParameters: {'ano': ano, 'mes': (mes)});
    if (res.data != null) {
      print(res.data);
      return res.data.map<PagamentosRetorno>((c) => PagamentosRetorno.fromJson(c)).toList() as List<PagamentosRetorno>;
    } else {
      return [];
    }
  }
}
