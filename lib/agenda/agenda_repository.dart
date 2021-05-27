import 'package:app_pilates/utils/custom_dio.dart';
import 'package:app_pilates/utils/formatos.dart';

import '../models/agenda_retorno.dart';

class AgendaRepository { 

  Future<List<AgendaRetorno>> buscar(DateTime? data) async {
    var dio = CustomDio.comAutenticacao().instancia;
    var params = Map<String, dynamic>();
    if (data != null)
      params['data'] = Formatos.dataYMD.format(data);

    var res = await dio.get('agenda', queryParameters: params);
    if (res.data != null) {
      return res.data.map<AgendaRetorno>((c) => AgendaRetorno.fromJson(c)).toList() as List<AgendaRetorno>;
    } else {
      return [];
    }
  }
}
