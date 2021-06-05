import 'package:app_pilates/utils/custom_dio.dart';

import '../models/agendamento.dart';

class AgendamentoRepository {

  Future<Agendamento> inserir(Agendamento agendamento) async {
    var dio = CustomDio.comAutenticacao().instancia;

    var res = await dio.post('agendamento', data: agendamento.toJson());
    return Agendamento.fromMap(res.data);    
  }

  Future<Agendamento> atualizar(Agendamento agendamento) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.put('agendamento/'+agendamento.id.toString(), data: agendamento.toJson());

    return Agendamento.fromMap(res.data);    
  }  

  Future<bool> excluir(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.delete('agendamento/'+id.toString());
    return res.statusCode != null && res.statusCode == 204;
  }

  Future<Agendamento> buscar(int id) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var res = await dio.get('agendamento/'+id.toString());
    if (res.data != null) {
      return Agendamento.fromMap(res.data);
    } else {
      return Agendamento();
    }
  }   

  Future<List<Agendamento>> listar(int? idAluno, String? data) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (idAluno != null)
      params['idAluno'] = idAluno;
    if (data != null)
      params['data'] = data;

    var res = await dio.get('agendamento', queryParameters: params);
    if (res.data != null) {
      return res.data.map<Agendamento>((c) => Agendamento.fromMap(c)).toList() as List<Agendamento>;
    } else {
      return [];
    }
  }
}
