import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reciepe_app2/show_food.dart';
import 'package:reciepe_app2/utils/colors.dart';
import 'package:reciepe_app2/view_all_page.dart';
import 'package:reciepe_app2/widgets/banner.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String selectedCategory = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "What are u\ncooking today?",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.notification),
                        iconSize: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    hintText: "Search any recipes",
                    hintStyle: TextStyle(fontSize: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MyBanner(),
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 10),
                  child: Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                CategoriesShowdown(
                  categorySelect: (String str) {
                    setState(() {
                      selectedCategory = str;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quick & Easy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ViewAllPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "View all",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                FoodsShowDown(selectedCategory: selectedCategory),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoodsShowDown extends StatefulWidget {
  final String selectedCategory;
  const FoodsShowDown({super.key, required this.selectedCategory});

  @override
  State<FoodsShowDown> createState() => _FoodsShowDownState();
}

class _FoodsShowDownState extends State<FoodsShowDown> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.selectedCategory == 'All'
          ? FirebaseFirestore.instance.collection("foods").snapshots()
          : FirebaseFirestore.instance
                .collection("foods")
                .where("category", isEqualTo: widget.selectedCategory)
                .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Text("No data found");
        }
        return SizedBox(
          width: double.infinity,
          height: 400,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 240,
                          width: 240,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ShowFood(
                                        name: snapshot.data!.docs[index]
                                            .data()['name'],
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Image.network(
                                snapshot.data!.docs[index].data()['image']
                                    as String,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,

                            child: GestureDetector(
                              onTap: () async {
                                final docRef =
                                    snapshot.data!.docs[index].reference;
                                final curr = snapshot.data!.docs[index]
                                    .data()['favourite'];
                                await docRef.update({'favourite': !curr});
                              },
                              child: Icon(
                                snapshot.data!.docs[index].data()['favourite']
                                    ? Iconsax.heart5
                                    : Iconsax.heart,
                                color:
                                    snapshot.data!.docs[index]
                                        .data()['favourite']
                                    ? Colors.red
                                    : Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      snapshot.data!.docs[index].data()["name"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Iconsax.flash_1),
                        Text(snapshot.data!.docs[index].data()["cal"] + " cal"),
                        Text(" - "),
                        Icon(Iconsax.clock),
                        Text(" "),
                        Text(
                          snapshot.data!.docs[index].data()["time"] + " min",
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CategoriesShowdown extends StatefulWidget {
  final Function(String) categorySelect;
  const CategoriesShowdown({super.key, required this.categorySelect});

  @override
  State<CategoriesShowdown> createState() => _CategoriesShowdownState();
}

class _CategoriesShowdownState extends State<CategoriesShowdown> {
  int slcted = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("categories")
          .doc("FflqeujL6EW1BhlkTupz")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("No data found");
        }
        List<dynamic> categories = snapshot.data!.get("name");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    slcted = index;
                  });
                  widget.categorySelect(categories[index]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Chip(
                    backgroundColor: slcted == index
                        ? kprimaryColor
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: kprimaryColor),
                    label: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: slcted == index ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
