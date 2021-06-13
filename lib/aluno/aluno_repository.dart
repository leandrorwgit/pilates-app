import 'package:app_pilates/utils/custom_dio.dart';

import '../models/aluno.dart';

class AlunoRepository {

  Future<Aluno> inserir(Aluno aluno) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('aluno', data: aluno.toJson());
    return Aluno.fromMap(res.data);    
  }

  Future<Aluno> atualizar(Aluno aluno) async {
    try {
      var dio = CustomDio.comAutenticacao().instancia;    
      var res = await dio.put('aluno/'+aluno.id.toString(), data: aluno.toJson());
      return Aluno.fromMap(res.data);    
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }  

  Future<bool> excluir(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.delete('aluno/'+id.toString());
    return res.statusCode != null && res.statusCode == 204;
  }

  Future<Aluno> buscar(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('aluno/'+id.toString());
    if (res.data != null) {
      return Aluno.fromMap(res.data);
    } else {
      return Aluno();
    }
  }   

  Future<List<Aluno>> listar(String? nome, bool? ativo) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (nome != null)
      params['nome'] = nome;
    if (ativo != null)
      params['ativo'] = ativo;

    var res = await dio.get('aluno', queryParameters: params);
    if (res.data != null) {
      return res.data.map<Aluno>((c) => Aluno.fromMap(c)).toList() as List<Aluno>;
    } else {
      return [];
    }
  }
}
