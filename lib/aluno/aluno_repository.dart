import 'package:app_pilates/utils/custom_dio.dart';

import '../models/aluno.dart';

class AlunoRepository {
  Future<List<Aluno>> buscar(String? nome, bool? ativo) {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (nome != null)
      params['nome'] = nome;
    if (ativo != null)
      params['ativo'] = ativo;

    return dio.get('aluno', queryParameters: params).then((res) {
      return res.data.map<Aluno>((c) => Aluno.fromMap(c)).toList()
          as List<Aluno>;
    }).catchError((err) => throw err);
  }
}
