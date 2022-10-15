import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  EditPage(
      {super.key,
      required this.docId,
      required this.docPath,
      required this.docData});
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String docId;
  final String docPath;
  final Map<String, dynamic> docData;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _cevapController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Page'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _cevapController,
            textAlign: TextAlign.start,
            expands: false,
            maxLines: 8,
            minLines: 1,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              isDense: false,
              alignLabelWithHint: true,
              hintText: "Cevap",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: NetworkImage(docData["falUrl"]),
              width: 400,
              height: 400,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () async {
                    ///delete

                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Sil',
                      desc:
                          'Bu fal silinecektir. Bu işlem geri alınamaz. Emin misiniz?',
                      btnCancelOnPress: () {},
                      btnOkText: "Evet",
                      btnCancelText: "Hayır",
                      btnOkOnPress: () async {
                        await FirebaseFirestore.instance.doc(docPath).delete();
                        await _storage.refFromURL(docData["falUrl"]).delete();
                        Navigator.pop(context);
                      },
                    ).show();
                  },
                  child: Text(
                    "Sil",
                    style: TextStyle(fontSize: 20),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () async {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Kaydet',
                      desc:
                          'Bu fal kaydedilecektir. Bu işlem geri alınamaz. Emin misiniz?',
                      btnCancelOnPress: () {},
                      btnOkText: "Evet",
                      btnCancelText: "Hayır",
                      btnOkOnPress: () async {
                        await FirebaseFirestore.instance.doc(docPath).update({
                          "cevap": _cevapController.text,
                          "isCevaplandi": true
                        });
                        Navigator.pop(context);
                      },
                    ).show();
                  },
                  child: Text(
                    "Kaydet",
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
