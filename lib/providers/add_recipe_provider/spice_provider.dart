
import 'package:flutter/cupertino.dart';
import 'package:kcpm/providers/add_recipe_provider/steps_provider.dart';

class SpiceProvider extends ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void addNewItem(String itemName) {
    final newItem = Item(id: DateTime.now().toString(), name: itemName);
    _items.add(newItem);
    notifyListeners();
  }

  void deleteItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateItem(String itemId, String newName) {
    final itemIndex = _items.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      _items[itemIndex].name = newName;
      notifyListeners();
    }
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
  }

  void moveItemUp(String itemId) {
    final itemIndex = _items.indexWhere((item) => item.id == itemId);
    if (itemIndex > 0) {
      final item = _items.removeAt(itemIndex);
      _items.insert(itemIndex - 1, item);
      notifyListeners();
    }
  }

  void moveItemDown(String itemId) {
    final itemIndex = _items.indexWhere((item) => item.id == itemId);
    if (itemIndex < _items.length - 1) {
      final item = _items.removeAt(itemIndex);
      _items.insert(itemIndex + 1, item);
      notifyListeners();
    }
  }

  void cleardata() {
    _items.clear();
    notifyListeners();
  }

  void updateItemsFormList(List<Item> newItems) {
    _items = newItems;
    notifyListeners();
  }
}
