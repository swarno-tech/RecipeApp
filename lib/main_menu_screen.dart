import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reciepe_app2/utils/colors.dart';
import 'package:reciepe_app2/widgets/banner.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int selected = 0;
  String selectedCategory = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconSize: 28,
        currentIndex: selected,
        selectedItemColor: kprimaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        onTap: (value) {
          selected = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(selected == 0 ? Iconsax.home5 : Iconsax.home1),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(selected == 1 ? Iconsax.heart5 : Iconsax.heart_add4),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(selected == 2 ? Iconsax.calendar5 : Iconsax.calendar),
            label: "Meal Plan",
          ),
          BottomNavigationBarItem(
            icon: Icon(selected == 3 ? Iconsax.setting_21 : Iconsax.setting1),
            label: "Setting",
          ),
        ],
      ),
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
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Iconsax.notification),
                      iconSize: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                MyBanner(),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 20),
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
                SizedBox(height: 20),
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
                    Text(
                      "View all",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
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
                            child: Image.network(
                              snapshot.data!.docs[index].data()['image']
                                  as String,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: CircleAvatar(
                            backgroundColor:
                                snapshot.data!.docs[index].data()['favourite']
                                ? Colors.red
                                : Colors.white,
                            child: GestureDetector(
                              onTap: () async {
                                final docRef =
                                    snapshot.data!.docs[index].reference;
                                final curr = snapshot.data!.docs[index]
                                    .data()['favourite'];
                                await docRef.update({'favourite': !curr});
                                setState(() {});
                              },
                              child: Icon(Iconsax.heart),
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
        List<dynamic> categories = snapshot.data!.get("name");
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
