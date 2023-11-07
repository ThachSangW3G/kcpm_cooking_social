class Category{
  final String id;
  final String image;
  final String name;

  Category({required this.id, required this.image, required this.name});

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
        id: json['id'],
        image: json['image'],
        name: json['name']
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Category &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              image == other.image &&
              name == other.name;

  @override
  int get hashCode => id.hashCode;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
    };
  }
}



List<Category> listCategory = [
  Category(id: '1', image: 'assets/images/background_1.jpg', name: 'Seasonal'),
  Category(id: '2', image: 'assets/images/background_splash_1.jpg', name: 'Cakes'),
  Category(id: '3', image: 'assets/images/background_splash_2.jpg', name: 'Everyday'),
  Category(id: '4', image: 'assets/images/background_splash_3.jpg', name: 'Drinks'),
  Category(id: '5', image: 'assets/images/background_1.jpg', name: 'Vegetarian'),
];


