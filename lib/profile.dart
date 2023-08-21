import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:login_dio/HomeScreen.dart';
import 'package:login_dio/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  // Fungsi untuk mengirim permintaan API untuk edit profile
  Future<void> editProfile(String newName, String newEmail) async {
    try {
      var response = await Dio().put(
        'https://example.com/api/edit_profile',
        data: {
          'name': newName,
          'email': newEmail,
        },
      );

      // Tambahkan logika untuk menangani respons dari API
      print(response.data); // Cetak respons dari API jika diperlukan
    } catch (error) {
      // Tangani error jika permintaan gagal
      print(error.toString());
    }
  }

  // Fungsi untuk mengirim permintaan API untuk edit password
  Future<void> editPassword(String newPassword) async {
    try {
      var response = await Dio().put(
        'https://example.com/api/edit_password',
        data: {
          'password': newPassword,
        },
      );

      // Tambahkan logika untuk menangani respons dari API
      print(response.data); // Cetak respons dari API jika diperlukan
    } catch (error) {
      // Tangani error jika permintaan gagal
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back), // Replace with your custom back icon if needed
          onPressed: () {
            // Navigate back to the home screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Abdillah Hasan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'abdillahhasan@example.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            buildProfileOption(
              context,
              Icons.person,
              'Edit Profile',
              EditProfileScreen(
                editProfile: editProfile,
              ),
            ),
            buildProfileOption(
              context,
              Icons.lock,
              'Edit Password',
              EditPasswordScreen(
                editPassword: editPassword,
              ),
            ),
            buildProfileOption(
              context,
              Icons.logout,
              'Logout',
              ProfileScreen(),
              onPressed: () {
                // Show a confirmation dialog before logging out
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Perform logout operation
                          // ...

                          // Navigate back to the HomeScreen or LoginScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileOption(
      BuildContext context, IconData icon, String title, Widget page,
      {Function()? onPressed}) {
    return InkWell(
      onTap: onPressed ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 16.0),
            Text(
              title,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  final Function(String, String) editProfile;

  EditProfileScreen({
    required this.editProfile,
  });

  @override
  Widget build(BuildContext context) {
    // Tambahkan kode untuk halaman edit profile di sini
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Halaman Edit Profile'),
      ),
    );
  }
}

class EditPasswordScreen extends StatelessWidget {
  final Function(String) editPassword;

  EditPasswordScreen({
    required this.editPassword,
  });

  @override
  Widget build(BuildContext context) {
    // Tambahkan kode untuk halaman edit password di sini
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
      ),
      body: Center(
        child: Text('Halaman Edit Password'),
      ),
    );
  }
}
