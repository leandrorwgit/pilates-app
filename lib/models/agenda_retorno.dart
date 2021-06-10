class AgendaRetorno {
  String? tipo;
  String? situacao;
  int? idAluno;
  String? descricao;
  String? horaIni;
  String? horaFim;
  String? dia;
  int? idEvolucao;

  AgendaRetorno({this.tipo, this.situacao, this.idAluno, this.descricao, this.horaIni, this.horaFim, this.dia, this.idEvolucao});

  AgendaRetorno.fromJson(Map<String, dynamic> json) {
    tipo = json['tipo'];
    situacao = json['situacao'];
    idAluno = json['idAluno'];
    descricao = json['descricao'];
    horaIni = json['horaIni'];
    horaFim = json['horaFim'];
    dia = json['dia'];
    idEvolucao = json['idEvolucao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tipo'] = this.tipo;
    data['situacao'] = this.situacao;
    data['idAluno'] = this.idAluno;
    data['descricao'] = this.descricao;
    data['horaIni'] = this.horaIni;
    data['horaFim'] = this.horaFim;
    data['dia'] = this.dia;
    data['idEvolucao'] = this.idEvolucao;
    return data;
  }
}