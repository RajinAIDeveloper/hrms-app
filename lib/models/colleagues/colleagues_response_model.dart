class ColleaguesResponseModel {
  List<Colleague> colleagues = [];
  ColleaguesResponseModel();

  ColleaguesResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['colleagues'] != null && json['colleagues'] is List) {
      colleagues = <Colleague>[];
      json['colleagues'].forEach((v) {
        colleagues.add(Colleague.fromJson(v));
      });
    } else {
      colleagues = [];
    }
  }
}

class Colleague {
  String? id = '0';
  String? text = '-';
  String? designationName = '-';
  String? officeEmail = '-';
  String? officeMobile = '-';
  String? photoPath = '-';
  String? bloodGroup = '-';

  Colleague(
      {this.id,
      this.text,
      this.designationName,
      this.officeEmail,
      this.officeMobile,
      this.photoPath,
      this.bloodGroup});

  Colleague.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '-';
    text = json['text'] ?? '-';
    designationName = json['designationName'] ?? '-';
    officeEmail = json['officeEmail'] ?? '-';
    officeMobile = json['officeMobile'] ?? '-';
    photoPath = json['photoPath'] ?? '-';
    bloodGroup = json['bloodGroup'] ?? '-';
  }
}
