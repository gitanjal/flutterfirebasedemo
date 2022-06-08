import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfiredemo/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  FlutterError.onError=FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasError)
          {
            return Text(snapshot.error.toString());
          }

          if(snapshot.connectionState==ConnectionState.active)
            {
               if(snapshot.data==null)
                 {
                   return LoginPage();
                 }
               else
                 {
                   return MyHomePage(title: FirebaseAuth.instance.currentUser!.displayName!);
                 }
            }

          return Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  CollectionReference _referenceShoppingList= FirebaseFirestore.instance.collection('shopping_list');
  late Stream<QuerySnapshot> _streamShoppingItems;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  initState(){
    super.initState();

    _streamShoppingItems=_referenceShoppingList.snapshots();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () async{
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.power_settings_new))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamShoppingItems,
        builder: (BuildContext context,AsyncSnapshot snapshot){

          if(snapshot.hasError)
            {
              return Center(child: Text(snapshot.error.toString()));
            }

          if(snapshot.connectionState==ConnectionState.active)
            {
              QuerySnapshot querySnapshot=snapshot.data;
              List<QueryDocumentSnapshot> listQueryDocumentSnapshot=querySnapshot.docs;

              return ListView.builder(
                  itemCount: listQueryDocumentSnapshot.length,
                  itemBuilder: (context,index){
                QueryDocumentSnapshot document=listQueryDocumentSnapshot[index];
                return Text(document['name']);
              });
            }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
