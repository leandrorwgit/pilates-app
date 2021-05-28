class AgendaRetorno {
  int? idAluno;
  String? descricao;
  String? horaIni;
  String? horaFim;
  String? dia;
  int? idEvolucao;

  AgendaRetorno({this.idAluno, this.descricao, this.horaIni, this.horaFim, this.dia, this.idEvolucao});

  AgendaRetorno.fromJson(Map<String, dynamic> json) {
    idAluno = json['idAluno'];
    descricao = json['descricao'];
    horaIni = json['horaIni'];
    horaFim = json['horaFim'];
    dia = json['dia'];
    idEvolucao = json['idEvolucao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idAluno'] = this.idAluno;
    data['descricao'] = this.descricao;
    data['horaIni'] = this.horaIni;
    data['horaFim'] = this.horaFim;
    data['dia'] = this.dia;
    data['idEvolucao'] = this.idEvolucao;
    return data;
  }
}