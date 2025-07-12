import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reciepe_app2/utils/colors.dart';

class ShowFood extends StatefulWidget {
  final String name;
  const ShowFood({super.key, required this.name});

  @override
  State<ShowFood> createState() => _ShowFoodState();
}

class _ShowFoodState extends State<ShowFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {},
        label: Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(kBannerColor),
                shadowColor: WidgetStatePropertyAll(Colors.grey),
              ),
              onPressed: () {},
              child: Text(
                "Start Cooking",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(width: 20),
            IconButton(onPressed: () {}, icon: Icon(Iconsax.heart)),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("foods")
            .where("name", isEqualTo: widget.name)
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!asyncSnapshot.hasData) {
            return Text("No data found");
          }
          return ListView.builder(
            itemCount: asyncSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          asyncSnapshot.data!.docs[index]['image'],
                        ),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
