class Review {
  String key;
  String uidUser;
  String name;
  String avatar;
  String description;
  String time;
  String keyRecipe;
  bool check;

  Review(
      {required this.uidUser,
        required this.description,
        required this.key,
        required this.avatar,
        required this.name,
        required this.time,
        required this.keyRecipe,
        required this.check});

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'uidUser': uidUser,
      'description': description,
      'time': time,
      'keyRecipe': keyRecipe,
    };
  }

  void setProperty(String propertyName, dynamic propertyValue) {
    if (propertyName == 'check') {
      check = propertyValue;
    }
    // Thêm các trường hợp xử lý cho các thuộc tính khác (nếu có)
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        key: json['key'],
        uidUser: json['uidUser'],
        description: json['description'],
        time: json['time'],
        keyRecipe: json['keyRecipe'],
        avatar: json['avatar'],
        name: json['name'],
        check: json['check']);
  }
}
