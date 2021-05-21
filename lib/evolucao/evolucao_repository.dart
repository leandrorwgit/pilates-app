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

  Future<bool> excluir(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.delete('evolucao/'+id.toString());
    return res.statusCode != null && res.statusCode == 204;
  }

  Future<List<Evolucao>> buscar(int? idAluno, String? data) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (idAluno != null)
      params['idAluno'] = idAluno;
    if (data != null)
      params['data'] = data;

    var res = await dio.get('evolucao', queryParameters: params);
    if (res.data != null) {
      return res.data.map<Evolucao>((c) => Evolucao.fromMap(c)).toList() as List<Evolucao>;
    } else {
      return [];
    }
  }
}
