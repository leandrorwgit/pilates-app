class AgendaRetorno {
  String? descricao;
  String? horaini;
  String? horafim;
  String? dia;

  AgendaRetorno({this.descricao, this.horaini, this.horafim, this.dia});

  AgendaRetorno.fromJson(Map<String, dynamic> json) {
    descricao = json['descricao'];
    horaini = json['horaini'];
    horafim = json['horafim'];
    dia = json['dia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['descricao'] = this.descricao;
    data['horaini'] = this.horaini;
    data['horafim'] = this.horafim;
    data['dia'] = this.dia;
    return data;
  }
}