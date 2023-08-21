import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:dio/dio.dart';
import 'HomeScreen.dart';
import 'PaymentPage.dart';

void main() {
  runApp(MyApp(
    token:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzFiNDFiMjY4MmEyYmQyZTg5NDhkZDVmYmNlMmJmMDQwMmI1ZDFlMWMzZDcxZmIyYjUwZjdkYWVkYWZkZjJhNTc1OTYyZjk1NzIwOGJmNWUiLCJpYXQiOjE2OTEzOTQwNDguMDAyMTE3LCJuYmYiOjE2OTEzOTQwNDguMDAyMTE5LCJleHAiOjE3MjMwMTY0NDcuOTkxNDc3LCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.RFTHvsu0JQSgzUxwnlfduv0gApdI1atsuoFI5NGlUxzi2bjApOcrOaNJ6aeABuo0mEwYjsRWhKU1oPoQKuFm1R-01W9Tpp0LdthmHrMQVAFetzquPHCZSTSowmnNwDj9N-D1h_a0Vi_T2RjPBzPERIMZeWECdjROBjWmpY2lk2qZp70yYi1LffbHpKwrW6B61lQeTd8RzNsarnSNuUNMdREtrPiaEDePDPeCZuw9gTRZcRj57qRgZSPipT1XufbMV-0ZIaM3Qiyhr_47vxRwLMaoK3DywXeSH6v5xWH88ed1jtIuyu_473LkBnFSxVAoZzQtFhC4Qt3dALy8ZHe9HRQdG6do--1kcVorlRch39_kgtwSGnG55JqhtLETp-MPi3aI7mByK8zQANSNAeaWIchIj-h7pl-CDVSR4UK_TipAWclCNchtbhi5IK4DUaXxAS-wywopzbRJ_gOCHQiiZDHgH0D6K-zDOKQoifsCVpnQT8ZfqaRdmAWiXmCYGYr5NcB98WEjSQETU4V9JmrggKxIZFFqRDORrJVUshdi3AH_zXYnD3uGc08gHvhBP8pGW74tPyk7uiU2Uu0a5jLucYCGuk6eeJ6cSwo3a1ERtITHF1Yqq2D_w779tH107EvEmlp4cwF5e6iFMqqxGzkpTn6Kb7B837PNzWJvzAoXaeU',
    data: {
      "product": [
        {
          "id": 1,
          "shop_id": 1,
          "name": "Product 1",
          "price": 10000,
          "image": "product1_image.jpg",
          "created_at": "2023-07-28T08:55:21.000000Z",
          "updated_at": "2023-07-28T08:55:21.000000Z"
        },
        {
          "id": 3,
          "shop_id": 1,
          "name": "Product 1",
          "price": 10000,
          "image": "product_image.jpg",
          "created_at": "2023-08-16T03:43:12.000000Z",
          "updated_at": "2023-08-16T03:43:12.000000Z"
        },
        {
          "id": 4,
          "shop_id": 2,
          "name": "Product 3",
          "price": 25000,
          "image": "product_image.jpg",
          "created_at": "2023-08-21T04:16:29.000000Z",
          "updated_at": "2023-08-21T04:16:29.000000Z"
        }
      ]
    },
  ));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic> data;
  final String token;

  MyApp({required this.data, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Point of Sale',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PointOfSale(data: data, token: token),
    );
  }
}

class PointOfSale extends StatefulWidget {
  final Map<String, dynamic> data;
  final String token;

  const PointOfSale({Key? key, required this.data, required this.token})
      : super(key: key);

  @override
  _PointOfSaleState createState() => _PointOfSaleState();
}

class _PointOfSaleState extends State<PointOfSale> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await Dio().get('http://10.0.2.2:8000/api/products');
      if (response.statusCode == 200) {
        setState(() {
          _products = List<Map<String, dynamic>>.from(response.data);
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

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add({...product, 'quantity': 1});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Point of Sale"),
        backgroundColor: const Color(0xFF343A40),
        actions: [
          badge.Badge(
            badgeContent: Text('${_cartItems.length}'),
            position: badge.BadgePosition.topEnd(top: 0, end: 3),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartItems: _cartItems,
                      data: widget.data,
                      token: widget.token,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(product['name']),
                      subtitle: Text('Price: \$${product['price']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          _addToCart(product);
                          print('Add ${product["name"]} to cart');
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, dynamic> data;
  final String token;

  CartPage(
      {Key? key,
      required this.cartItems,
      required this.data,
      required this.token})
      : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double calculateTotalAmount() {
    double total = 0;
    for (var cartItem in widget.cartItems) {
      total += (cartItem['price'] * cartItem['quantity']);
    }
    return total;
  }

  Future<void> _performTransaction() async {
    try {
      final response = await Dio().post(
        'http://your-api-url.com/api/process-transaction',
        data: widget.cartItems,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Transaction successful');
      } else {
        print('Transaction failed');
      }
    } catch (error) {
      print('Error performing transaction: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: const Color(0xFF343A40),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];
                int quantity = cartItem['quantity'] ?? 1;

                return ListTile(
                  title: Text(cartItem['name']),
                  subtitle: Text('Price: \$${cartItem['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                              cartItem['quantity'] = quantity;
                            }
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                            cartItem['quantity'] = quantity;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.cartItems.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await _performTransaction();
                double totalAmount = calculateTotalAmount();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(totalAmount: totalAmount),
                  ),
                );
              },
              child: Text('Lanjut ke Pembayaran'),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final double totalAmount;

  PaymentPage({required this.totalAmount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isPaymentProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isPaymentProcessing = true;
    });

    try {
      final paymentResponse = await Dio().post(
        'http://your-api-url.com/api/process-payment',
        data: {
          'total_amount': widget.totalAmount,
          // Add other payment details here
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer your-access-token',
          },
        ),
      );

      if (paymentResponse.statusCode == 200) {
        print('Payment successful');
      } else {
        print('Payment failed');
      }
    } catch (error) {
      print('Error processing payment: $error');
    }

    setState(() {
      _isPaymentProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: const Color(0xFF343A40),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPaymentProcessing ? null : _processPayment,
                child: _isPaymentProcessing
                    ? CircularProgressIndicator()
                    : Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
