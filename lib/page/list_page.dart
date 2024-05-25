import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import '../model/kopi_model.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  List<JenisKopi>? jenis = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://fake-coffee-api.vercel.app/api'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        jenis = responseData.map((json) => JenisKopi.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('login', true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
            icon: Icon(Icons.logout, color: Colors.white,),
          )
        ],
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "List Kopi",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: jenis?.length ?? 0,
                itemBuilder: (context, index) {
                  final kopi = jenis![index];
                  return ListTile(
                    title: Text(
                      kopi.name ?? '',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text(kopi.description ?? ''),
                    onTap: () {
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
