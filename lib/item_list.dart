import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final CollectionReference _referenceShoppingList =
      FirebaseFirestore.instance.collection('shopping_list');

  late Stream<QuerySnapshot> _streamData;
  // late Future<QuerySnapshot> _futureData;
  // List<Map> _shoppingItems = [];

  @override
  initState() {
    super.initState();

    _streamData=_referenceShoppingList.snapshots();
    // _futureData = _referenceShoppingList.get();
    /*_futureData.then((value) {
      setState(() {
        _shoppingItems = parseData(value);
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<QuerySnapshot>(
          stream: _streamData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if(snapshot.hasError)
              {
                return const Center(child: Text('Some error occurred'));
              }

            if(snapshot.hasData)
              {
                List<Map> items=parseData(snapshot.data);
                return buildListView(items);
              }

            return Center(child: CircularProgressIndicator());

          },
        ));
  }

  List<Map> parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List<Map> listItems = listDocs
        .map((e) => {'item_name': e['name'], 'item_quantity': e['quantity']})
        .toList();

    return listItems;
  }

  ListView buildListView(List<Map<dynamic, dynamic>> shoppingItems) {
    return ListView.builder(
        itemCount: shoppingItems.length,
        itemBuilder: (context, index) {
          Map thisItem = shoppingItems[index];
          return ListTile(
            title: Text(thisItem['item_name']),
            subtitle: Text(thisItem['item_quantity']),
          );
        });
  }
}
