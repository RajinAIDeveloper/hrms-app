class KeyValuePairList {
  List<KeyValuePair> keyValuePair = [];

  KeyValuePairList();

  KeyValuePairList.fromJson(Map<String, dynamic> json) {
    if (json['keyValuePairList'] != null && json['keyValuePairList'] is List) {
      keyValuePair = <KeyValuePair>[];
      json['keyValuePairList'].forEach((v) {
        keyValuePair.add(KeyValuePair.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyValuePairList'] = keyValuePair.map((v) => v.toJson()).toList();
    return data;
  }
}

class KeyValuePair {
  String? id;
  String? name;

  KeyValuePair({this.name, this.id});

  KeyValuePair.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
