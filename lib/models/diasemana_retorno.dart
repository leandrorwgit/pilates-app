class DiaSemanaRetorno {
  String? totalAulaSeg;
  String? totalAulaTer;
  String? totalAulaQua;
  String? totalAulaQui;
  String? totalAulaSex;
  String? totalAulaSab;

  DiaSemanaRetorno(
      {this.totalAulaSeg,
      this.totalAulaTer,
      this.totalAulaQua,
      this.totalAulaQui,
      this.totalAulaSex,
      this.totalAulaSab});

  DiaSemanaRetorno.fromJson(Map<String, dynamic> json) {
    totalAulaSeg = json['totalAulaSeg'];
    totalAulaTer = json['totalAulaTer'];
    totalAulaQua = json['totalAulaQua'];
    totalAulaQui = json['totalAulaQui'];
    totalAulaSex = json['totalAulaSex'];
    totalAulaSab = json['totalAulaSab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAulaSeg'] = this.totalAulaSeg;
    data['totalAulaTer'] = this.totalAulaTer;
    data['totalAulaQua'] = this.totalAulaQua;
    data['totalAulaQui'] = this.totalAulaQui;
    data['totalAulaSex'] = this.totalAulaSex;
    data['totalAulaSab'] = this.totalAulaSab;
    return data;
  }
}