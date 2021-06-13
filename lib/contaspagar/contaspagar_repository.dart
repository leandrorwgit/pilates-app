import 'package:app_pilates/utils/custom_dio.dart';

import '../models/contaspagar.dart';

class ContasPagarRepository {

  Future<ContasPagar> inserir(ContasPagar contasPagar) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('contaspagar', data: contasPagar.toJson());
    return ContasPagar.fromMap(res.data);    
  }

  Future<ContasPagar> atualizar(ContasPagar contasPagar) async {
    try {
      var dio = CustomDio.comAutenticacao().instancia;      
      var res = await dio.put('contaspagar/'+contasPagar.id.toString(), data: contasPagar.toJson());
      return ContasPagar.fromMap(res.data);    
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }  

  Future<bool> excluir(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.delete('contaspagar/'+id.toString());
    return res.statusCode != null && res.statusCode == 204;
  }

  Future<ContasPagar> buscar(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('contaspagar/'+id.toString());
    if (res.data != null) {
      return ContasPagar.fromMap(res.data);
    } else {
      return ContasPagar();
    }
  }   

  Future<List<ContasPagar>> listar(String? descricao, bool? ativo) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (descricao != null)
      params['descricao'] = descricao;
    if (ativo != null)
      params['ativo'] = ativo;

    var res = await dio.get('contaspagar', queryParameters: params);
    if (res.data != null) {
      return res.data.map<ContasPagar>((c) => ContasPagar.fromMap(c)).toList() as List<ContasPagar>;
    } else {
      return [];
    }
  }
}
