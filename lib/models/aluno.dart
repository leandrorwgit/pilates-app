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
  bool? ativo;

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
      this.ativo});

  static Aluno getTeste() {
    return new Aluno(
        id: 1,
        nome: 'Leandro',
        idade: 35,
        dataNascimento: DateTime.parse('1986-06-10'),
        profissao: 'Programador',
        celular: '47 98846-4794',
        email: 'leandrorw@yahoo.com.br',
        objetivosPilates: 'Melhorar qualidade de vida',
        queixas: 'Dor na coluna',
        formaPagamento: 'Pix',
        diaPagamento: 10,
        aulaSeg: true,
        aulaTer: false,
        aulaQua: true,
        aulaQui: false,
        aulaSex: false,
        aulaSab: false,
        ativo: true);
  }
}
