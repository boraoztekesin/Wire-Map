class StationModel {
  int? id;
  int? host;
  String? latitude;
  String? longitude;
  String? chargeSpeed;
  bool? isBlocked;
  bool? isBeingUsed;
  String? price;
  StationModel({
    this.id,
    this.host,
    this.latitude,
    this.longitude,
    this.chargeSpeed,
    this.isBlocked,
    this.isBeingUsed,
    this.price,
  });
  StationModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    host = json['host']?.toInt();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    chargeSpeed = json['charge_speed']?.toString();
    isBlocked = json['is_blocked'];
    isBeingUsed = json['is_being_used'];
    price = json['price']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['host'] = host;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['charge_speed'] = chargeSpeed;
    data['is_blocked'] = isBlocked;
    data['is_being_used'] = isBeingUsed;
    data['price'] = price;
    return data;
  }
}
