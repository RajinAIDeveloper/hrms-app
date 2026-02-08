// models/account_head_dto.dart
class AccountHeadDTO {
  int? headId;
  String? headName;
  String? type;

  AccountHeadDTO({
    this.headId,
    this.headName,
    this.type,
  });

  factory AccountHeadDTO.fromJson(Map<String, dynamic> json) {
    return AccountHeadDTO(
      headId: json['HeadId'],
      headName: json['HeadName'],
      type: json['Type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'HeadId': headId,
      'HeadName': headName,
      'Type': type,
    };
  }
}