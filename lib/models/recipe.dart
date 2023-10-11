class Recipe {
  String key;
  String url;
  String name;
  int cookTime;
  String description;
  String difficult;
  bool isPublic;
  List<String> material;
  int numberLike;
  String category;
  int numberReView;
  int serves;
  String source;
  List<String> spice;
  List<String> steps;
  String uidUser;
  Recipe(
      {required this.key,
        required this.url,
        required this.name,
        required this.cookTime,
        required this.description,
        required this.difficult,
        required this.isPublic,
        required this.material,
        required this.category,
        required this.numberLike,
        required this.numberReView,
        required this.serves,
        required this.source,
        required this.spice,
        required this.steps,
        required this.uidUser});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        key: json['id'] as String,
        url: json['URL'] as String,
        name: json['name'] as String,
        cookTime: json['cookTime'] as int,
        description: json['description'] as String,
        difficult: json['difficult'] as String,
        isPublic: json['isPublic'] as bool,
        material: List<String>.from(json['material']),
        numberLike: json['numberLike'] as int,
        numberReView: json['numberReview'] as int,
        serves: json['serves'] as int,
        source: json['source'] as String,
        category: json['category'] as String,
        spice: List<String>.from(json['spice']),
        steps: List<String>.from(json['steps']),
        uidUser: json['uidUser'] as String);
  }
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'URL': url,
      'name': name,
      'cookTime': cookTime,
      'description': description,
      'difficult': difficult,
      'isPublic': isPublic,
      'material': material,
      'numberLike': numberLike,
      'numberReView': numberReView,
      'category': category,
      'serves': serves,
      'source': source,
      'spice': spice,
      'steps': steps,
      'uidUser': uidUser
    };
  }
}
