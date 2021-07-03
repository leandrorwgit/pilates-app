import '../models/pagamentos_cr_retorno.dart';
import '../models/contasreceberpagamento.dart';
import '../utils/custom_dio.dart';

class ContasReceberPagamentoRepository {

  Future<ContasReceberPagamento> inserir(ContasReceberPagamento pagamento) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('contasreceberpagamento', data: pagamento.toJson());
    return ContasReceberPagamento.fromMap(res.data);    
  }

  Future<ContasReceberPagamento> atualizar(ContasReceberPagamento pagamento) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.put('contasreceberpagamento/'+pagamento.id.toString(), data: pagamento.toJson());

    return ContasReceberPagamento.fromMap(res.data);    
  }  

  Future<bool> excluir(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.delete('contasreceberpagamento/'+id.toString());
    return res.statusCode != null && res.statusCode == 204;
  }

  Future<ContasReceberPagamento> buscar(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('contasreceberpagamento/'+id.toString());
    if (res.data != null) {
      return ContasReceberPagamento.fromMap(res.data);
    } else {
      return ContasReceberPagamento();
    }
  }   

  Future<List<ContasReceberPagamento>> listar(int? idAluno, String? data) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (idAluno != null)
      params['idAluno'] = idAluno;
    if (data != null)
      params['data'] = data;

    var res = await dio.get('contasreceberpagamento', queryParameters: params);
    if (res.data != null) {
      return res.data.map<ContasReceberPagamento>((c) => ContasReceberPagamento.fromMap(c)).toList() as List<ContasReceberPagamento>;
    } else {
      return [];
    }
  }

  Future<List<PagamentosCrRetorno>> listarPagamentos(int ano, int mes) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('contasreceberpagamento/pagamentos', queryParameters: {'ano': ano, 'mes': (mes)});
    if (res.data != null) {
      return res.data.map<PagamentosCrRetorno>((c) => PagamentosCrRetorno.fromJson(c)).toList() as List<PagamentosCrRetorno>;
    } else {
      return [];
    }
  }
}
