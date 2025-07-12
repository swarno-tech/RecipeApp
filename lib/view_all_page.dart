import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reciepe_app2/utils/colors.dart';

class ViewAllPage extends StatefulWidget {
  const ViewAllPage({super.key});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        title: Text(
          "ALL",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("foods").snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!asyncSnapshot.hasData) {
            return Text("No data found");
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemCount: asyncSnapshot.data!.docs.length,
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
                              asyncSnapshot.data!.docs[index].data()['image']
                                  as String,
                              fit: BoxFit.cover,
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
                                    asyncSnapshot.data!.docs[index].reference;
                                final curr = asyncSnapshot.data!.docs[index]
                                    .data()['favourite'];
                                await docRef.update({'favourite': !curr});
                              },
                              child: Icon(
                                asyncSnapshot.data!.docs[index]
                                        .data()['favourite']
                                    ? Iconsax.heart5
                                    : Iconsax.heart,
                                color:
                                    asyncSnapshot.data!.docs[index]
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
                      asyncSnapshot.data!.docs[index].data()["name"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Iconsax.flash_1),
                        Text(
                          asyncSnapshot.data!.docs[index].data()["cal"] +
                              " cal",
                        ),
                        Text(" - "),
                        Icon(Iconsax.clock),
                        Text(" "),
                        Text(
                          asyncSnapshot.data!.docs[index].data()["time"] +
                              " min",
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Iconsax.people),
                        Text(
                          asyncSnapshot.data!.docs[index].data()["reviews"] +
                              " reviews",
                        ),
                        Text(" - "),
                        Icon(Iconsax.star),
                        Text(" "),
                        Text(
                          asyncSnapshot.data!.docs[index].data()["rating"] +
                              "/5",
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
