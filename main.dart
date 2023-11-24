import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/event_model.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyHome()));
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<EventModel> details = [];

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Firestore'),
      ),
      body: ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, position) {
          return Dismissible(
            key: Key(details[position].id ?? UniqueKey().toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              return await _showDeleteConfirmationDialog(context, position);
            },
            onDismissed: (direction) {
              deleteEvent(position);
            },
            child: ListTile(
              title: Text(details[position].judul),
              subtitle: Text(
                  '${details[position].keterangan} \nHari : ${details[position].tanggal} \nPembicara : ${details[position].pembicara}'),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(context, position);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _showAddDialog(BuildContext context) async {
    TextEditingController judulController = TextEditingController();
    TextEditingController keteranganController = TextEditingController();
    TextEditingController tanggalController = TextEditingController();
    TextEditingController pembicaraController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: keteranganController,
                decoration: InputDecoration(labelText: "Keterangan"),
              ),
              TextField(
                controller: tanggalController,
                decoration: InputDecoration(labelText: "Tanggal"),
              ),
              TextField(
                controller: pembicaraController,
                decoration: InputDecoration(labelText: "Pembicara"),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addEvent(
                        judulController.text,
                        keteranganController.text,
                        tanggalController.text,
                        pembicaraController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future _showEditDialog(BuildContext context, int position) async {
    TextEditingController judulController =
        TextEditingController(text: details[position].judul);
    TextEditingController keteranganController =
        TextEditingController(text: details[position].keterangan);
    TextEditingController tanggalController =
        TextEditingController(text: details[position].tanggal);
    TextEditingController pembicaraController =
        TextEditingController(text: details[position].pembicara);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: keteranganController,
                decoration: InputDecoration(labelText: "Keterangan"),
              ),
              TextField(
                controller: tanggalController,
                decoration: InputDecoration(labelText: "Tanggal"),
              ),
              TextField(
                controller: pembicaraController,
                decoration: InputDecoration(labelText: "Pembicara"),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      updateEvent(
                          position,
                          judulController.text,
                          keteranganController.text,
                          tanggalController.text,
                          pembicaraController.text);
                      Navigator.pop(context);
                    },
                    child: Text("Update"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future testData() async {
    await Firebase.initializeApp();
    print('Init done');
    FirebaseFirestore db = await FirebaseFirestore.instance;
    print('init Firestore done');

    var data = await db.collection('event_detail').get().then((event) {
      for (var doc in event.docs) {
        print('${doc.id} => ${doc.data()}');
      }
    });
  }

  Future readData() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = await FirebaseFirestore.instance;

    var data = await db.collection('event_detail').get();
    setState(() {
      details =
          data.docs.map((doc) => EventModel.fromDocSnapshot(doc)).toList();
    });
  }

  addEvent(
      String judul, String keterangan, String tanggal, String pembicara) async {
    FirebaseFirestore db = await FirebaseFirestore.instance;
    EventModel insertData = EventModel(
        judul: judul,
        keterangan: keterangan,
        tanggal: tanggal,
        isLike: Random().nextBool(),
        pembicara: pembicara);

    await db.collection('event_detail').add(insertData.toMap());
    setState(() {
      details.add(insertData);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Event Berhasil Ditambahkan"),
    ));
  }

  Future _showDeleteConfirmationDialog(
      BuildContext context, int position) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Penghapusan"),
          content: Text("Apakah Anda yakin ingin menghapus event ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm
              },
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  Future deleteEvent(int position) async {
    bool confirmDelete = await _showDeleteConfirmationDialog(context, position);

    if (confirmDelete != null && confirmDelete) {
      FirebaseFirestore db = await FirebaseFirestore.instance;
      EventModel deletedEvent =
          details[position]; // Store the deleted event for undo

      await db.collection('event_detail').doc(deletedEvent.id).delete();
      setState(() {
        details.removeAt(position);
      });

      // Show Snackbar with Undo action
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Event Berhasil Dihapus"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            // Undo the deletion
            db.collection('event_detail').add(deletedEvent.toMap());
            setState(() {
              details.add(deletedEvent);
            });
          },
        ),
      ));
    }
  }

  updateEvent(int position, String judul, String keterangan, String tanggal,
      String pembicara) async {
    if (position >= 0 &&
        position < details.length &&
        details[position].id != null) {
      FirebaseFirestore db = await FirebaseFirestore.instance;

      // Check if the document exists before updating
      var docSnapshot =
          await db.collection('event_detail').doc(details[position].id).get();
      if (docSnapshot.exists) {
        await db.collection('event_detail').doc(details[position].id).update({
          'Judul': judul,
          'Keterangan': keterangan,
          'tanggal': tanggal,
          'Pembicara': pembicara,
        });
        setState(() {
          details[position].judul = judul;
          details[position].keterangan = keterangan;
          details[position].tanggal = tanggal;
          details[position].pembicara = pembicara;
        });

        // Show Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event Berhasil Diupdate'),
          ),
        );
      } else {
        print('Dokumen tidak ada: ${details[position].id}');
      }
    } else {
      print('Posisi tidak valid atau ID dokumen hilang: $position');
    }
  }
}
