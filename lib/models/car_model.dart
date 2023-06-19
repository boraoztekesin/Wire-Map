class CarModel {
  int? id;
  int? user;
  int? carRange;
  String? efficiency;
  String? model;

  CarModel({
    this.id,
    this.user,
    this.carRange,
    this.efficiency,
    this.model,
  });
  CarModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    user = json['user']?.toInt();
    carRange = json['car_range']?.toInt();
    efficiency = json['efficiency']?.toString();
    model = json['model']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user;
    data['car_range'] = carRange;
    data['efficiency'] = efficiency;
    data['model'] = model;
    return data;
  }
}
