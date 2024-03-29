import 'dart:convert';

class Aluno {
  int? id;
  String? nome;
  int? idade;
  DateTime? dataNascimento;
  String? profissao;
  String? celular;
  String? email;
  String? objetivosPilates;
  String? queixas;
  String? formaPagamento; // Pix/Dinheiro/Deposito/DOC
  int? diaPagamento;
  bool? aulaSeg;
  bool? aulaTer;
  bool? aulaQua;
  bool? aulaQui;
  bool? aulaSex;
  bool? aulaSab;
  String? aulaHorarioInicio;
  int? aulaDuracao;
  bool? ativo;
  String? aulaHorarioInicioSeg;
  String? aulaHorarioInicioTer;
  String? aulaHorarioInicioQua;
  String? aulaHorarioInicioQui;
  String? aulaHorarioInicioSex;
  String? aulaHorarioInicioSab;
  double? valorPagamento;

  Aluno({
      this.id,
      this.nome,
      this.idade,
      this.dataNascimento,
      this.profissao,
      this.celular,
      this.email,
      this.objetivosPilates,
      this.queixas,
      this.formaPagamento,
      this.diaPagamento,
      this.aulaSeg,
      this.aulaTer,
      this.aulaQua,
      this.aulaQui,
      this.aulaSex,
      this.aulaSab,
      this.aulaHorarioInicio,
      this.aulaDuracao,
      this.ativo,
      this.aulaHorarioInicioSeg,
      this.aulaHorarioInicioTer,
      this.aulaHorarioInicioQua,
      this.aulaHorarioInicioQui,
      this.aulaHorarioInicioSex,
      this.aulaHorarioInicioSab,
      this.valorPagamento});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'profissao': profissao,
      'celular': celular,
      'email': email,
      'objetivosPilates': objetivosPilates,
      'queixas': queixas,
      'formaPagamento': formaPagamento,
      'diaPagamento': diaPagamento,
      'aulaSeg': aulaSeg,
      'aulaTer': aulaTer,
      'aulaQua': aulaQua,
      'aulaQui': aulaQui,
      'aulaSex': aulaSex,
      'aulaSab': aulaSab,
      'aulaHorarioInicio': aulaHorarioInicio,
      'aulaDuracao': aulaDuracao,
      'ativo': ativo,
      'aulaHorarioInicioSeg': aulaHorarioInicioSeg,
      'aulaHorarioInicioTer': aulaHorarioInicioTer,
      'aulaHorarioInicioQua': aulaHorarioInicioQua,
      'aulaHorarioInicioQui': aulaHorarioInicioQui,
      'aulaHorarioInicioSex': aulaHorarioInicioSex,
      'aulaHorarioInicioSab': aulaHorarioInicioSab,
      'valorPagamento': valorPagamento != null ? valorPagamento!.toStringAsFixed(2) : null,
    };
  }

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
      dataNascimento: DateTime.parse(map['dataNascimento']),
      profissao: map['profissao'],
      celular: map['celular'],
      email: map['email'],
      objetivosPilates: map['objetivosPilates'],
      queixas: map['queixas'],
      formaPagamento: map['formaPagamento'],
      diaPagamento: map['diaPagamento'],
      aulaSeg: map['aulaSeg'],
      aulaTer: map['aulaTer'],
      aulaQua: map['aulaQua'],
      aulaQui: map['aulaQui'],
      aulaSex: map['aulaSex'],
      aulaSab: map['aulaSab'],
      aulaHorarioInicio: map['aulaHorarioInicio'],
      aulaDuracao: map['aulaDuracao'],
      ativo: map['ativo'],
      aulaHorarioInicioSeg: map['aulaHorarioInicioSeg'],
      aulaHorarioInicioTer: map['aulaHorarioInicioTer'],
      aulaHorarioInicioQua: map['aulaHorarioInicioQua'],
      aulaHorarioInicioQui: map['aulaHorarioInicioQui'],
      aulaHorarioInicioSex: map['aulaHorarioInicioSex'],
      aulaHorarioInicioSab: map['aulaHorarioInicioSab'],
      valorPagamento: map['valorPagamento'] != null ? double.tryParse(map['valorPagamento']) ?? 0 : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Aluno.fromJson(String source) => Aluno.fromMap(json.decode(source));
}
