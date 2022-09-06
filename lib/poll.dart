import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({Key? key}) : super(key: key);

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poll'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(96.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: () {
                vote(false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(
                    Icons.icecream,
                  ),
                  Text('Ice-cream',),
                ],
              ),
            ),
            MaterialButton(
              onPressed: () {
                vote(true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(
                    Icons.local_pizza,
                  ),
                  Text('Pizaa',),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future vote(bool voteForPizza)async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference collection = db.collection('poll');
    QuerySnapshot snapshot = await collection.get();

    List<QueryDocumentSnapshot> list = snapshot.docs;
    DocumentSnapshot document = list[0];
    final id = document.id;

    if(voteForPizza){
      int pizzaVotes = document.get('pizza');
      collection.doc(id).update({'pizza':++pizzaVotes});
    }else{
      int icecreamVotes = document.get('icecream');
      collection.doc(id).update({'icecream':++icecreamVotes});
    }
  }
}
