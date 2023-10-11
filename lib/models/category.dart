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
}

List<Category> listCategory = [
  Category(id: '1', image: 'assets/images/background_1.jpg', name: 'Seasonal'),
  Category(id: '2', image: 'assets/images/background_splash_1.jpg', name: 'Cakes'),
  Category(id: '3', image: 'assets/images/background_splash_2.jpg', name: 'Everyday'),
  Category(id: '4', image: 'assets/images/background_splash_3.jpg', name: 'Drinks'),
  Category(id: '5', image: 'assets/images/background_1.jpg', name: 'Vegetarian'),
];


