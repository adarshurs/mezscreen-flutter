class Device {
  String? key;
  String? name;
  String? type;
  int? value;

  Device({this.key, this.name, this.type, this.value});

  Device.fromJson(String deviceKey, Map<String, dynamic> json) {
    key = deviceKey;
    name = json['name'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['value'] = value;
    return data;
  }

  @override
  String toString() {
    return 'Device{key: $key, name: $name, type: $type, value: $value}';
  }
}
