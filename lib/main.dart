import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'HomeScreen.dart';
import 'constants/apis.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (email != null && password != null) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = true;
      });
    }
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Please enter both email and password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // try {
    // final response = await Dio().post(
    //   'http://10.0.2.2:8000/api/login',
    //   data: {
    //     'email': email,
    //     'password': password,
    //   },
    // );
    try {
      final response = await Dio().post(
        "${Apis.getLogin}",
        data: {
          'email': email,
          'password': password,
        },
      );
      // if (response.statusCode == 200) {
      //   setState(() {
      //     _login() =
      //         List<Map<String, dynamic>>.from(response.data['data']['token']);
      //     _isLoading = false;
      //   });

      // Memeriksa respons dari server
      if (response.statusCode == 200) {
        // Mengambil data user dari respons
        final data = response.data['data'];
        final token = data['token'];
        String shopId = "${data['user']['shop_id']}";

        if (_rememberMe) {
          await _storage.write(key: 'email', value: email);
          await _storage.write(key: 'password', value: password);
        } else {
          await _storage.delete(key: 'email');
          await _storage.delete(key: 'password');
        }
        await _storage.write(
          key: 'shop_id',
          value: shopId,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Login gagal, tampilkan pesan kesalahan
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid credentials. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Error saat melakukan permintaan HTTP
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred. Please try again. $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white10,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80.0),
            Image.asset(
              'assets/cerebrum.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'WHAT IT IS HO, WASSAP?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48.0),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black45,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Remember Me'),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}


// code cadangan
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'HomeScreen.dart';
// import 'constants/apis.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _isPasswordVisible = false;
//   bool _rememberMe = false;

//   final _storage = FlutterSecureStorage();

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCredentials();
//   }

//   Future<void> _loadSavedCredentials() async {
//     final email = await _storage.read(key: 'email');
//     final password = await _storage.read(key: 'password');

//     if (email != null && password != null) {
//       setState(() {
//         _emailController.text = email;
//         _passwordController.text = password;
//         _rememberMe = true;
//       });
//     }
//   }

//   Future<void> _login() async {
//     final String email = _emailController.text;
//     final String password = _passwordController.text;

//     if (email.isEmpty || password.isEmpty) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Login Failed'),
//           content: const Text('Please enter both email and password.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await Dio().post(
//         "${Apis.getLogin}",
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = response.data['data'];
//         final token = data['user']['token'];
//         String shopId = "${data['user']['shop_id']}";

//         if (_rememberMe) {
//           await _storage.write(key: 'email', value: email);
//           await _storage.write(key: 'password', value: password);
//         } else {
//           await _storage.delete(key: 'email');
//           await _storage.delete(key: 'password');
//         }
//         await _storage.write(
//           key: 'shop_id',
//           value: shopId,
//         );

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Login Failed'),
//             content: const Text('Invalid credentials. Please try again.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (error) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: Text('An error occurred. Please try again. $error'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         color: Colors.white10,
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 80.0),
//             Image.asset(
//               'assets/cerebrum.png',
//               width: 150,
//               height: 150,
//             ),
//             const SizedBox(height: 8.0),
//             const Text(
//               'WHAT IT IS HO, WASSAP?',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 48.0),
//             TextFormField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               style: const TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 labelStyle: const TextStyle(color: Colors.black),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextFormField(
//               controller: _passwordController,
//               obscureText: !_isPasswordVisible,
//               style: const TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 labelStyle: const TextStyle(color: Colors.black),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                     color: Colors.black45,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Checkbox(
//                   value: _rememberMe,
//                   onChanged: (value) {
//                     setState(() {
//                       _rememberMe = value ?? false;
//                     });
//                   },
//                 ),
//                 const Text('Remember Me'),
//               ],
//             ),
//             const SizedBox(height: 24.0),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _login,
//               child: _isLoading
//                   ? const CircularProgressIndicator()
//                   : const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
