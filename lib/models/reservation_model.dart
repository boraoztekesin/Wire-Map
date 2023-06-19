class ReservationModel {
  int? id;
  int? host;
  int? station;
  int? client;
  int? duration;
  String? date;
  String? price;
  bool? isApproved;

  ReservationModel({
    this.id,
    this.host,
    this.station,
    this.client,
    this.duration,
    this.date,
    this.price,
    this.isApproved,
  });
  ReservationModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    host = json['host']?.toInt();
    station = json['station']?.toInt();
    client = json['client']?.toInt();
    duration = json['duration']?.toInt();
    date = json['date']?.toString();
    price = json['price']?.toString();
    isApproved = json['is_approved'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['host'] = host;
    data['station'] = station;
    data['client'] = client;
    data['duration'] = duration;
    data['date'] = date;
    data['price'] = price;
    data['is_approved'] = isApproved;
    return data;
  }
}
