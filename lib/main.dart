import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCyfo5JCfHSW8GxZxUj8UM7EltATdu_g9M",
          appId: "1:1084933523084:android:affbc629bddc4d6c8e9da9",
          messagingSenderId: "1084933523084",
          projectId: "mechanical-tools-b086b"
      )
  );

  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      UserCredential? userCredential =
      await signInWithEmailAndPassword(email, password);
      if (userCredential != null) {
        setState(() {
          errorMessage = null; // Clear any previous error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );

        // Navigate to MyApp after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      } else {
        setState(() {
          errorMessage = 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Display the error message
      });
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade800, Colors.orange.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mechanics',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.build, color: Colors.black, size: 30),
                  ],
                ),
                Text(
                  'Tools',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter Email...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MechanicsToolsScreen(),
    );
  }
}

class MechanicsToolsScreen extends StatefulWidget {
  @override
  _MechanicsToolsScreenState createState() => _MechanicsToolsScreenState();
}

class _MechanicsToolsScreenState extends State<MechanicsToolsScreen> {
  String selectedCategory = 'Screw Drivers';
  String searchQuery = '';
  late List<Tool> displayedTools;

  @override
  void initState() {
    super.initState();
    displayedTools = toolItems;
  }

  void updateSearchResults(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      displayedTools = toolItems
          .where((tool) => tool.name.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade700,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
        title: Text(
          "Mechanics Tools",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              final selectedTools =
              toolItems.where((tool) => tool.quantity > 0).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CheckoutScreen(selectedTools: selectedTools),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 8, bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: toolCategories.length,
              itemBuilder: (context, index) {
                final category = toolCategories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      displayedTools = toolItems
                          .where((tool) => tool.name.contains(category))
                          .toList();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: selectedCategory == category
                          ? Colors.orange.shade900
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: updateSearchResults,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: displayedTools.length,
              itemBuilder: (context, index) {
                final tool = displayedTools[index];
                return buildToolTile(tool);
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget buildToolTile(Tool tool) {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image.network(
          tool.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          tool.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₱ ${tool.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (tool.quantity > 0) tool.quantity--;
                    });
                  },
                ),
                Text(
                  '${tool.quantity}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      tool.quantity++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.red],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mechanics\nTools',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to MechanicsToolsScreen
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'View Products',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Log out and navigate back to LoginScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolsListScreen extends StatelessWidget {
  final List<Tool> tools;
  final String title;

  ToolsListScreen({required this.tools, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
      ),
      body: tools.isEmpty
          ? Center(
        child: Text(
          'No tools available in this category!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return Card(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Image.network(
                tool.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                tool.name,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('₱ ${tool.price.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  final List<Tool> selectedTools;

  CheckoutScreen({required this.selectedTools});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double getTotalPrice() {
    // Calculate the total price of items in the cart
    return widget.selectedTools.fold(
        0, (sum, tool) => sum + (tool.price * tool.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // Remove all items from cart
              setState(() {
                widget.selectedTools.clear();
              });
            },
          ),
        ],
      ),
      body: widget.selectedTools.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: widget.selectedTools.length,
              itemBuilder: (context, index) {
                final tool = widget.selectedTools[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      tool.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(tool.name),
                    subtitle: Text(
                        'Quantity: ${tool.quantity}\n₱ ${(tool.price * tool.quantity).toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.orange),
                          onPressed: () {
                            setState(() {
                              if (tool.quantity > 1) {
                                tool.quantity -= 1; // Decrement quantity
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Minimum quantity is 1")),
                                );
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              tool.quantity += 1; // Increment quantity
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.selectedTools.removeAt(index); // Remove item
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${tool.name} removed from cart")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Total: ₱ ${getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Perform checkout action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Proceeding to checkout...")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Tool and Categories Data
class Tool {
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  Tool({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 0,
  });
}

List<Tool> toolItems = [
  Tool(name: 'Screw Driver Orange ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTepk0huKIhUfWDgpmkK83aPxsGi93yermz0A&s'),
  Tool(name: 'Screw Driver Steel ', price: 100.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjW9pufFgaavX6armeFj5mOB7amYfX2QFc3Q&s'),
  Tool(name: 'Screw Driver Yellow ', price: 150.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLB3Os0P3KNl1YYTbC_bwtM2LL3foeBLR2mw&s'),
  Tool(name: 'Screw Driver Black Orange ', price: 80.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRETLJN01tWNSdhbni7pi2IaV5-Mys21pxZ4A&s'),
  Tool(name: 'Screw Driver Violet ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5QNsl70yfHFM9_m5JJENDpJRagWNcoOgeNQ&s'),
  Tool(name: 'Screw Driver Orange Black ', price: 95.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6KKYyWJuAh_UH5v_8ldKmYsNB5ryxC8WVUQ&s'),

  Tool(name: 'Wheel Wrench ', price: 95.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvQLB2XrcgI5c4Ga1NOMkae-OGj46ajX19KA&s'),
  Tool(name: 'Wheel Wrench Single socket', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_1WMiqhCeJ-OCQAHLaujUFoVSlvrdAA1PEQ&s'),
  Tool(name: 'Wheel Wrench 2pcs ', price: 100.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROXbfuzfKt5BUFGoYld0Xkg0v-1lMqorZtDA&s'),
  Tool(name: 'Wheel Wrench Black ', price: 150.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjul-5utr5DZepf7bmkooNEdtzztbUWIKKFg&s'),
  Tool(name: 'Wheel Wrench Set ', price: 80.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRxGQXkviLa_W9Z1N81exzhTemUEFyZsXLNA&s'),
  Tool(name: 'Wheel Wrench 2pcs ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0KWszRpQ6KJxv232PVl-2eBX5fRiBMZplRQ&s'),

  Tool(name: 'Crescent Yellow ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAUH0Ro09X_Gx3wQ4qz58RxUODsEweZPT6_Q&s'),
  Tool(name: 'Crescent 3pcs ', price: 100.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZ8DIvLFdeQQFF6Ms2O4BER4lE3eRYQ9ZN2Q&s'),
  Tool(name: 'Crescent Set ', price: 150.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnktefWTz1Heol-UWjwgdX_rynAoQYD5MjmQ&s'),
  Tool(name: 'Crescent ', price: 80.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSL51Vu5wz01utw4zhIdZduGFIFYL7NJCKAQA&s'),
  Tool(name: 'Crescent set A ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTra-vBL3KjfuYRg3XhXBow5FFDrdUF8UKHuQ&s'),
  Tool(name: 'Crescent (1) ', price: 95.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsiO5FzyDB9-uIdNxUIt2yTSqXNiUaVPP-Xg&s'),

  Tool(name: 'Socket T wrench ', price: 95.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOmFSunPH565VaDxmXYqZG61dmEE0dAPKRFw&s'),
  Tool(name: 'Socket Top Tools Set ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMkxnYp6zWA-T0m87nfgcUGkaGqWq-KCFO8g&s'),
  Tool(name: 'Socket Set Tools C ', price: 100.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREsDmF74nXmwWCSjBlDX_Q6hVRm7Yw0eKqIw&s'),
  Tool(name: 'Socket Set Tools B ', price: 150.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSn_9Vb5BhK229ea52FSPdRVDdgGeylAJxOyg&s'),
  Tool(name: 'Socket Set Tools A ', price: 80.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTL97Nxa3p9g0LCxIzPF3jYUVW1NK_25UIGEg&s'),
  Tool(name: 'Socket Ratchet Wrench Set ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvWWMJoVk5G8_5U6CkdWD0JN3SN3l__H2tkg&s'),

  Tool(name: 'FlashLight Black ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNEtlohkT64vsiVLMwhmfNFlA5ZV9UyFyoLA&s'),
  Tool(name: 'FlashLight Red ', price: 100.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbZuGEHbfcXzZNTx3xtC9SyWLNy4heFGg6Bw&s'),
  Tool(name: 'FlashLight Head', price: 150.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJUfD1z8xor4g53YgBKQ82pNMcIfSQhyDviA&s'),
  Tool(name: 'FlashLight Rubber ', price: 80.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTB5fs93dfCBtgzolSYiC9yRWVERVY8MLDgw&s'),
  Tool(name: 'FlashLight Gray ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSBKPHiEMJLWIYAVggd8t6-s3wquCPyD7Nag&s'),
  Tool(name: 'FlashLight Set ', price: 95.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjInuQGgpN0NPIJnImOwnHe2-mDZC4sYxKhg&s'),

  Tool(name: 'Dog Bone 2pcs ', price: 95.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZiUBLFCcvvRqbdAfYrFQJxGYzUVwxDYbyIQ&s'),
  Tool(name: 'Dog Bone ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7Dv7oKe7NxXyv4Q0f-jgRZgGN_E09CoWDYJWKtM92t8r1sRK7qfxqbqwt8vm-szATQYU&usqp=CAU'),
  Tool(name: 'Dog Bone Light Blue', price: 100.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqRLgRDczuXds-cShzcTfIVW9Qn3wz1tWK6Q&s'),
  Tool(name: 'Dog Bone Single', price: 150.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTztyre3RD1ST2oToW5nNSKmcquW1vkHc3u6w&s'),
  Tool(name: 'Dog Bone 360 ', price: 80.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQR88uyXUz9C42UObFjs922CqCQIr6kUNW7-g&s'),
  Tool(name: 'Dog Bone Set ', price: 50.0, imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjKZAmRAR3eqlZqXeogBYRJ79ZU_YICKFnyQ&s'),

];



List<String> toolCategories = [
  'Screw Driver',
  'Wheel Wrench',
  'Socket',
  'Crescent',
  'Dog Bone',
  'FlashLight',
];