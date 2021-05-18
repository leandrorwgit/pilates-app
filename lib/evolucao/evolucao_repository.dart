import 'package:app_pilates/utils/custom_dio.dart';

import '../models/evolucao.dart';

class EvolucaoRepository {

  Future<Evolucao> inserir(Evolucao evolucao) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('evolucao', data: evolucao.toJson());
    return Evolucao.fromMap(res.data);    
  }

  Future<Evolucao> atualizar(Evolucao evolucao) async {
    var dio = CustomDio.comAutenticacao().instancia;
  
    var res = await dio.put('evolucao/'+evolucao.id.toString(), data: evolucao.toJson());
    return Evolucao.fromMap(res.data);    
  }  

  Future<List<Evolucao>> buscar(String? nome, bool? ativo) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (nome != null)
      params['nome'] = nome;
    if (ativo != null)
      params['ativo'] = ativo;

    var res = await dio.get('evolucao', queryParameters: params);
    return res.data.map<Evolucao>((c) => Evolucao.fromMap(c)).toList() as List<Evolucao>;
  }
}
