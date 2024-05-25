import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:responsi_tpm/page/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsi_tpm/page/home_page.dart';
import 'package:responsi_tpm/model//login_model.dart';
import 'package:responsi_tpm/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late SharedPreferences loginData;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLoggedIn();
  }

  void checkIfAlreadyLoggedIn() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);
    print("new user = $newUser");
    if (!newUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login Menu",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: userController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: passController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(onPressed: (){
                    String user = userController.text;
                    String pass = passController.text;
                    var box = Hive.box<LoginModel>(loginBox);

                    for (var item in box.values) {
                      if (item.username == user && item.password == pass) {
                        print("Login Berhasil");
                        loginData.setBool('login', false);
                        loginData.setString('username', user);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                        return;
                      }
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Username atau Password salah.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );

                  },
                      child: Text('Login'),
                  ),
                  SizedBox(height: 12.0),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                      child: Text('Belum Punya Akun?', style: TextStyle(color: Colors.deepPurple),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
