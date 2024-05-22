import 'package:flutter/material.dart';
import 'package:first_project/models/product.dart';

class Cart extends ChangeNotifier {
  final Map<String, int> _items = {};

  List<Product> _productList = [];

  List<Product> get productList => _productList;

  Map<String, int> get items => _items;

  double get totalPrice {
    double total = 0.0;
    _items.forEach((productId, quantity) {
      total += _productList.firstWhere((product) => product.id == productId).price * quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id] = _items[product.id]! + 1;
    } else {
      _items[product.id] = 1;
      _productList.add(product);
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    if (_items.containsKey(product.id) && _items[product.id]! > 1) {
      _items[product.id] = _items[product.id]! - 1;
    } else {
      _items.remove(product.id);
      _productList.remove(product);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(product.id);
    _productList.remove(product);
    notifyListeners();
  }
}
