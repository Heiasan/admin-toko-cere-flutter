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
      home: LoginScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username = "";
  late String email = "";

  @override
  void initState() {
    super.initState();
    // fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      // var response = await Dio().get(
      //   'http://10.0.2.2:8000/api/login', // Ganti dengan URL yang sesuai
      // );

      // var data = response.data;

      // setState(() {
      //   username = data['username'];
      //   email = data['email'];
      // });
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> editProfile(String newName, String newEmail) async {
    try {
      var response = await Dio().put(
        'http://10.0.2.2:8000/api/admin/update',
        data: {
          'name': newName,
          'email': newEmail,
        },
      );

      print(response.data);
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> editPassword(String newPassword) async {
    try {
      var response = await Dio().put(
        'http://10.0.2.2:8000/api/admin/update',
        data: {
          'password': newPassword,
        },
      );

      print(response.data);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Tampilkan dialog konfirmasi sebelum logout
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Lakukan operasi logout
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
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
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    email,
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

class EditProfileScreen extends StatefulWidget {
  final Function(String, String) editProfile;

  EditProfileScreen({
    required this.editProfile,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _newNameController = TextEditingController();
  TextEditingController _newEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newNameController,
              decoration: InputDecoration(
                labelText: 'New Name',
                icon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newEmailController,
              decoration: InputDecoration(
                labelText: 'New Email',
                icon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String newName = _newNameController.text;
                String newEmail = _newEmailController.text;
                widget.editProfile(newName, newEmail);
                Navigator.pop(context); // Kembali ke halaman profile
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPasswordScreen extends StatefulWidget {
  final Function(String) editPassword;

  EditPasswordScreen({
    required this.editPassword,
  });

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String newPassword = _newPasswordController.text;
                // Add logic to compare newPassword and confirmPassword
                widget.editPassword(newPassword);
                Navigator.pop(context); // Kembali ke halaman profile
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
