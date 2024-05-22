import 'package:first_project/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_project/models/product.dart';
import 'package:first_project/models/cart.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> _products = [];
  Map<String, int> _cartItems = {};
  Set<String> _wishlistItems = {}; 

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final url = Uri.parse('https://makeup-api.herokuapp.com/api/v1/products.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Product> loadedProducts = [];

        responseData.forEach((productData) {
          var priceString = productData['price'] ?? '';
          var id = productData['id'] ?? '';
          var name = productData['name'] ?? '';
          var brand = productData['brand'] ?? '';
          var imageURL = productData['image_link'] ?? '';

          if (priceString.isNotEmpty) {
            double price = 0.0;
            try {
              price = double.parse(priceString);
            } catch (e) {
              print('Error  price for product $id: $e');
            }

            loadedProducts.add(Product(
              id: id.toString(),
              name: name,
              brand: brand,
              price: price,
              imageURL: imageURL,
            ));
          } else {
            print('Price is null or empty for products $id');
          }
        });

        setState(() {
          _products = loadedProducts;
        });
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Makeup Products Is Here'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (_cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 9,
                      child: Text(
                        '${_cartItems.values.reduce((sum, element) => sum + element)}',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: _products.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.0, 
                      runSpacing: 10.0, 
                      children: _products.map((product) {
                        final bool isInWishlist = _wishlistItems.contains(product.id);
                        return Card(
                          color: Colors.white,
                          // elevation: 4, 
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 30) / 2, // Adjust the width as needed
                            child: Column(
                              children: [
                                Container(
                                  height: 120,
                                  child: Image.network(
                                    product.imageURL,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              isInWishlist
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isInWishlist ? Colors.pink : null,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (isInWishlist) {
                                                  _wishlistItems.remove(product.id);
                                                } else {
                                                  _wishlistItems.add(product.id);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(product.brand),
                                      SizedBox(height: 5),
                                      Text('\$${product.price.toStringAsFixed(2)}'),
                                      SizedBox(height: 5),
                                      IconButton(
                                        icon: Icon(Icons.add_shopping_cart),
                                        onPressed: () {
                                          setState(() {
                                            var productId = product.id;
                                            if (_cartItems.containsKey(productId)) {
                                              _cartItems[productId] =
                                                  _cartItems[productId]! + 1;
                                            } else {
                                              _cartItems[productId] = 1;
                                            }
                                          });
                                          Provider.of<Cart>(context, listen: false)
                                              .addItem(product);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Product Added to cart'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
