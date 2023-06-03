import 'package:database/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'insert.dart';
import 'update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'realtime CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DatabaseReference db_Ref =
        FirebaseDatabase.instance.ref().child('contacts');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ccreate(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '明細',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
        backgroundColor: mainColor,
      ),
      body: FirebaseAnimatedList(
        query: db_Ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          Map Contact = snapshot.value as Map;
          Contact['key'] = snapshot.key;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateRecord(
                    Contact_Key: Contact['key'],
                  ),
                ),
              );
              // print(Contact['key']);
            },
            child: Container(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.greenAccent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: mainColor2,
                  trailing: Container(
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.grey[900],
                          ),
                          onPressed: () {
                            db_Ref.child(Contact['key']).remove();
                          },
                        ),
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      Contact['url'],
                    ),
                  ),
                  title: Text(
                    Contact['name'],
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    Contact['number'],
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          );
        },
      ),
    );
  }
}
