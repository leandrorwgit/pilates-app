import 'package:app_pilates/utils/custom_dio.dart';

import '../models/aluno.dart';

class AlunoRepository {

  Future<Aluno> inserir(Aluno aluno) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('aluno', data: aluno.toJson());
    return Aluno.fromMap(res.data);    
  }

  Future<Aluno> atualizar(Aluno aluno) async {
    var dio = CustomDio.comAutenticacao().instancia;
  
    var res = await dio.put('aluno/'+aluno.id.toString(), data: aluno.toJson());
    return Aluno.fromMap(res.data);    
  }  

  Future<List<Aluno>> buscar(String? nome, bool? ativo) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (nome != null)
      params['nome'] = nome;
    if (ativo != null)
      params['ativo'] = ativo;

    var res = await dio.get('aluno', queryParameters: params);
    return res.data.map<Aluno>((c) => Aluno.fromMap(c)).toList() as List<Aluno>;
  }
}
