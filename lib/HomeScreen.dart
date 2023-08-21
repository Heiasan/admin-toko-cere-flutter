import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'POS.dart';
import 'CRUDProduk.dart';
import 'profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> dailyIncome = [];
  List<double> weeklyIncome = [];
  List<double> monthlyIncome = [];
  List<double> yearlyIncome = [];

  @override
  void initState() {
    super.initState();
    fetchIncomeData();
  }

  Future<void> fetchIncomeData() async {
    try {
      var response = await Dio().get('http://10.0.2.2:8000/api/sales-report/1');

      if (response.data.containsKey('daily_income') &&
          response.data.containsKey('weekly_income') &&
          response.data.containsKey('monthly_income') &&
          response.data.containsKey('yearly_income')) {
        setState(() {
          dailyIncome = List<double>.from(response.data['daily_income']);
          weeklyIncome = List<double>.from(response.data['weekly_income']);
          monthlyIncome = List<double>.from(response.data['monthly_income']);
          yearlyIncome = List<double>.from(response.data['yearly_income']);
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Preview'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Daily Income Preview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: dailyIncome.length.toDouble() - 1,
                    minY: 0,
                    maxY: dailyIncome.isNotEmpty
                        ? dailyIncome.reduce((max, e) => e > max ? e : max)
                        : 10,
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: dailyIncome.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value);
                        }).toList(),
                        isCurved: true,
                        colors: [Colors.blue],
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Weekly Income Preview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: weeklyIncome.length.toDouble() - 1,
                    minY: 0,
                    maxY: weeklyIncome.isNotEmpty
                        ? weeklyIncome.reduce((max, e) => e > max ? e : max)
                        : 10,
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: weeklyIncome.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value);
                        }).toList(),
                        isCurved: true,
                        colors: [Colors.orange],
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Monthly Income Preview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: monthlyIncome.length.toDouble() - 1,
                    minY: 0,
                    maxY: monthlyIncome.isNotEmpty
                        ? monthlyIncome.reduce((max, e) => e > max ? e : max)
                        : 10,
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: monthlyIncome.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value);
                        }).toList(),
                        isCurved: true,
                        colors: [Colors.green],
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Yearly Income Preview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: yearlyIncome.length.toDouble() - 1,
                    minY: 0,
                    maxY: yearlyIncome.isNotEmpty
                        ? yearlyIncome.reduce((max, e) => e > max ? e : max)
                        : 10,
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: yearlyIncome.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value);
                        }).toList(),
                        isCurved: true,
                        colors: [Colors.purple],
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TaskBar(),
    );
  }
}

class TaskBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TaskBarButton(
            text: 'POS',
            icon: Icons.store,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PointOfSale(
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
                              ],
                            },
                          )));
            },
          ),
          TaskBarButton(
            text: 'CRUDProduk',
            icon: Icons.shopping_bag,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CRUDProduk()));
            },
          ),
          TaskBarButton(
            text: 'Profile',
            icon: Icons.person,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class TaskBarButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  TaskBarButton(
      {required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: TextButton.styleFrom(primary: Colors.blue),
    );
  }
}
