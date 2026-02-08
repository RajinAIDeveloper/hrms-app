class LeaveTypeDropdownResponseModel {
  List<LeaveTypeDropdown> leaveTypes = [];
  LeaveTypeDropdownResponseModel();

  LeaveTypeDropdownResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['leaveTypes'] != null && json['leaveTypes'] is List) {
      leaveTypes = <LeaveTypeDropdown>[];
      json['leaveTypes'].forEach((v) {
        leaveTypes.add(LeaveTypeDropdown.fromJson(v));
      });
    } else {
      leaveTypes = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaveTypes'] = leaveTypes.map((v) => v.toJson()).toList();
    return data;
  }
}

class LeaveTypeDropdown {
  String? id;
  String? value;
  String? text;
  String? count;
  String? max;

  LeaveTypeDropdown({
    this.id,
    this.value,
    this.text,
    this.count,
    this.max,
  });

  LeaveTypeDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    value = json['value'] ?? '';
    text = json['text'] ?? '';
    count = json['count'] ?? '';
    max = json['max'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['text'] = text;
    data['count'] = count;
    data['max'] = max;

    return data;
  }
}
