import 'aluno.dart';

class Evolucao {
  int? id;
  Aluno? aluno;
  DateTime? data;
  String? comoChegou;
  String? condutasUtilizadas;
  String? aparelhosUtilizados;
  String? comoSaiu;
  String? orientacoesDomiciliares;

  Evolucao(
      {this.id,
      this.aluno,
      this.data,
      this.comoChegou,
      this.condutasUtilizadas,
      this.aparelhosUtilizados,
      this.comoSaiu,
      this.orientacoesDomiciliares});

  static Evolucao getTeste() {
    return Evolucao(
      id: 1,
      aluno: Aluno.getTeste(),
      data: DateTime.now(),
      comoChegou: 'Disposto e sem queixas',
      condutasUtilizadas:
          'Fortalecimento de MMSS, MMII, abdômen e coluna lombar; estabilização escapular e pélvica; mobilização de ombros, quadris e coluna vertebral; alongamento de cadeia lateral de tronco e MMII',
      aparelhosUtilizados: 'Chair;Cadillac',
      comoSaiu: 'Bem e sem queixas',
      orientacoesDomiciliares: 'Nenhuma',
    );
  }
}
