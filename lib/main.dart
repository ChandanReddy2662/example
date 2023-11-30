import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'asserts';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aridnik Share',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: MyAppState(),
    );
  }
}

class MyAppState extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

final TextEditingController _uname = TextEditingController();
final TextEditingController _pass = TextEditingController();

class AppState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            title: Text("Aridnik Share"),
            centerTitle: true,
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(children: [
                    SizedBox(width: 8),
                    TextButton(
                      child: Text(
                        '\$100.00', // Replace with your actual balance value
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                    ),
                  ])),
            ]),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 500,
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _uname,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      )),
                ),
                Container(
                    margin: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _pass,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageStateHolder()));
                    },
                    child: Text("Login")),
              ]))
        ])));
  }
}

class ImageStateHolder extends StatefulWidget {
  @override
  ImageState createState() => ImageState();
}

List mapRes = [];

class ImageState extends State {
  Future apicall() async {
    http.Response response =
        await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if (response.statusCode == 200) {
      setState(() {
        mapRes = json.decode(response.body)['data'];
      });
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  Future shareWA(card) async {
    Uri whatsappUrl = Uri.parse('https://wa.me/?og:image=${Uri.encodeFull("hi")}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      print('Could not launch $whatsappUrl');
    }
  }

  Future shareFB(card) async {
     final response = await http.post(
    Uri.parse('https://graph.facebook.com/v15.0/me/feed/'),
    body: {
      'message': 'message',
      'access_token': 200,
    },
  );
    if (response.statusCode == 200) {
    print('Post successful');
  } else {
    print('Post failed with status ${response.statusCode}');
  }
  }

  Future shareX(card) async {
    Uri whatsappUrl =
        Uri.parse('https://www.twitter.com//?text=${Uri.encodeFull("hi")}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      print('Could not launch $whatsappUrl');
    }
  }

  Future shareIG(card) async {
    Uri whatsappUrl =
        Uri.parse('https://www.instagram.com//?text=${Uri.encodeFull("hi")}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      print('Could not launch $whatsappUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (context, index) {
                Card curr = Card(
                  child: Column(children: [
                    Image.network(mapRes[index]['avatar']),
                    Text(mapRes[index]['avatar']),
                  ]),
                );
                return Column(
                  children: [
                    curr,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            shareWA(mapRes[index]['avatar']);
                          },
                          icon: Image.asset('PNG/whatsapp.png'),
                        ),
                        IconButton(
                          onPressed: () {
                            shareFB("card");
                          },
                          icon: Image.asset('PNG/facebook.png'),
                        ),
                        IconButton(
                          onPressed: () {
                            shareX("card");
                          },
                          icon: Image.asset('PNG/x.png'),
                          iconSize: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            shareIG("card");
                          },
                          icon: Image.asset('PNG/instagram.png'),
                        )
                      ],
                    )
                  ],
                );
              },
              itemCount: mapRes.length,
            )));
  }
}
