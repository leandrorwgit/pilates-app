import 'package:app_pilates/utils/custom_dio.dart';

import '../models/configuracao.dart';

class ConfiguracaoRepository {

  Future<Configuracao> inserir(Configuracao configuracao) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('configuracao', data: configuracao.toJson());
    return Configuracao.fromMap(res.data);    
  }

  Future<Configuracao> atualizar(Configuracao configuracao) async {
    try {
      var dio = CustomDio.comAutenticacao().instancia;    
      var res = await dio.put('configuracao/'+configuracao.id.toString(), data: configuracao.toJson());
      return Configuracao.fromMap(res.data);    
    } on Exception catch (e) {
      throw e;
    }
  }  

  Future<bool> excluir(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.delete('configuracao/'+id.toString());
    return res.statusCode != null && res.statusCode == 204;
  }

  Future<Configuracao> buscar(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('configuracao/'+id.toString());
    if (res.data != null) {
      return Configuracao.fromMap(res.data);
    } else {
      return Configuracao();
    }
  }   

  Future<List<Configuracao>> listar() async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('configuracao');
    if (res.data != null) {
      return res.data.map<Configuracao>((c) => Configuracao.fromMap(c)).toList() as List<Configuracao>;
    } else {
      return [];
    }
  }
}
