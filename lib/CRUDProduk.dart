import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:login_dio/HomeScreen.dart';
import 'package:login_dio/main.dart';
import 'constants/apis.dart';

class CRUDProduk extends StatefulWidget {
  const CRUDProduk({Key? key}) : super(key: key);

  @override
  _CRUDProdukState createState() => _CRUDProdukState();
}

class _CRUDProdukState extends State<CRUDProduk> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get('http://10.0.2.2:8000/api/products');
      if (response.statusCode == 200) {
        setState(() {
          _products = List<Map<String, dynamic>>.from(response.data['data']);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProduct(String productId, String newName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.put(
        'http://10.0.2.2:8000/api/products/1',
        data: {
          'name': newName,
        },
      );

      if (response.statusCode == 200) {
        print('Product updated successfully: $productId, $newName');
        _fetchProducts();
      } else {
        throw Exception('Failed to update product');
      }
    } catch (error) {
      print('Error updating product: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.delete(
        'http://10.0.2.2:8000/api/products/2',
      );

      if (response.statusCode == 200) {
        print('Product deleted successfully: $productId');
        _fetchProducts();
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      print('Error deleting product: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
        title: const Text("CRUD Produk"),
        backgroundColor: const Color(0xFF343A40),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 2.0,
                    child: ListTile(
                      leading: Image.network(
                        product['imageUrl'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product['name']),
                      subtitle: Text('Price: \$${product['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  String newName = product['name'];
                                  return AlertDialog(
                                    title: const Text('Update Product'),
                                    content: TextField(
                                      onChanged: (value) => newName = value,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _updateProduct(
                                              product['id'], newName);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Update'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Product'),
                                    content: const Text(
                                        'Are you sure you want to delete this product?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          _deleteProduct(product['id']);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String productName = '';
              double productPrice = 0.0;
              return AlertDialog(
                title: const Text('Create Product'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) => productName = value,
                      decoration: InputDecoration(labelText: 'Product Name'),
                    ),
                    TextField(
                      onChanged: (value) {
                        try {
                          productPrice = double.parse(value);
                        } catch (e) {
                          productPrice = 0.0;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Product Price'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Call the API to create a new product here
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
