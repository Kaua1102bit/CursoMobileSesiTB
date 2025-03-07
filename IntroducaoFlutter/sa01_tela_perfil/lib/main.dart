import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<TextEditingController> _controllers = List.generate(7, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // estudo do scaffold
      home: Scaffold(
        // app bar barra de navegação superior
        appBar: AppBar(
          title: Text(""),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        // corpo do aplicativo
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_forward, size: 30),
              ),
              SizedBox(height: 10),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/img/image.png'),
              ),
              SizedBox(height: 10),
              Text(
                'Kauã Santos',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(Icons.star, color: Colors.yellow);
                }),
              ),
              Text(
                'Limeira-SP',
                style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: 100,
                    height: 100,
                    color: const Color.fromARGB(255, 0, 255, 34),
                    child: Center(child: Text("Balance 00:00")),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: 100,
                    height: 100,
                    color: const Color.fromARGB(255, 0, 255, 21),
                    child: Center(child: Text("Orders 10")),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: 100,
                    height: 100,
                    color: const Color.fromARGB(255, 0, 255, 21),
                    child: Center(child: Text("Total Spent 00:00")),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Personal Information'),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text('Your Order'),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Your Favorites'),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.payment),
                      title: Text('Payment'),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.shop),
                      title: Text('Shop'),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.store),
                      title: Text('Recommended Shops'),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Logout'),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Cloud',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: const Color.fromARGB(255, 65, 57, 57),
          onTap: (index) {
            // Handle item tap
          },
        ),
      ),
    );
  }
}