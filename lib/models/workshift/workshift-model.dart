class WorkshiftResponsemodel {
  List<Workshiftlist> workshiftlist = [];
  WorkshiftResponsemodel();

  WorkshiftResponsemodel.fromJson(Map<String, dynamic> json) {
    if (json['workshiftlist'] != null && json['workshiftlist'] is List) {
      workshiftlist = <Workshiftlist>[];
      json['workshiftlist'].forEach((v) {
        workshiftlist.add(Workshiftlist.fromJson(v));
      });
    } else {
      workshiftlist = [];
    }
  }
}

class Workshiftlist {
  String? id = '0';
  String? text = '-';
  String? designationName = '-';
  String? officeEmail = '-';
  String? officeMobile = '-';
  String? photoPath = '-';
  String? bloodGroup = '-';

  Workshiftlist(
      {this.id,
      this.text,
      this.designationName,
      this.officeEmail,
      this.officeMobile,
      this.photoPath,
      this.bloodGroup});

  Workshiftlist.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '-';
    text = json['text'] ?? '-';
    designationName = json['designationName'] ?? '-';
    officeEmail = json['officeEmail'] ?? '-';
    officeMobile = json['officeMobile'] ?? '-';
    photoPath = json['photoPath'] ?? '-';
    bloodGroup = json['bloodGroup'] ?? '-';
  }
}
