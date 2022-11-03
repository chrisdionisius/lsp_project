class Log {
  int? id;
  int? userId;
  String? location;
  String? timestamp;

  Log({this.id, this.userId, this.location, this.timestamp});

  Log.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    location = json['location'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['location'] = location;
    data['timestamp'] = timestamp;
    return data;
  }
}
