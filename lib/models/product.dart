

import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageURL;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageURL,
  });
}

class ProductListScreen extends StatelessWidget {
  final List<Product> dummyProducts = [
    Product(
      id: '1',
      name: 'Product 1',
      brand: 'Brand 1',
      price: 10.99,
      imageURL: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '2',
      name: 'Product 2',
      brand: 'Brand 2',
      price: 20.99,
      imageURL: 'https://via.placeholder.com/150',
    ),
    Product(
      id: '3',
      name: 'Product 3',
      brand: 'Brand 3',
      price: 30.99,
      imageURL: 'https://via.placeholder.com/150',
    ),
    // Add more dummy products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Makeup Products'),
      ),
      body: ListView.builder(
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(product.imageURL),
            ),
            title: Text(product.name),
            subtitle: Text(product.brand),
            trailing: Text('\$${product.price.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProductListScreen(),
  ));
}
