import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falcigaciadmin/views/editpage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore _database = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Falcı Gacı Fal Listesi'),
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text("${index + 1}. Fal"),
                    onTap: () {
                      print("${snapshot.data!.docs[index].reference.path}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPage(
                                  docId: snapshot.data!.docs[index].id,
                                  docPath:
                                      snapshot.data!.docs[index].reference.path,
                                  docData: snapshot.data!.docs[index].data())));
                    },
                    onLongPress: () {
                      ///delete
                      snapshot.data!.docs[index].reference.delete();
                    },
                  ));
                });
          }

          if (snapshot.hasError) {
            return Container(
              child: Text("error, ${snapshot.error}"),
            );
          }
          return Container(
            child: CircularProgressIndicator(),
          );
        },
        stream: _database
            .collectionGroup("fallar")
            .where("isCevaplandi", isEqualTo: false)
            .snapshots(),
      ),
    );
  }
}
