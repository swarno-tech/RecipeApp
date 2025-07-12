import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reciepe_app2/utils/colors.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        title: Text(
          "Favourites",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("foods")
              .where("favourite", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text("Found no data"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data!.docs[index].data()["name"],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
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
                    leading: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Image.network(
                        snapshot.data!.docs[index].data()["image"],
                      ),
                    ),
                    trailing: IconButton(
                      iconSize: 25,
                      onPressed: () async {
                        final docRef = snapshot.data!.docs[index].reference;
                        final curr = snapshot.data!.docs[index]
                            .data()['favourite'];
                        await docRef.update({'favourite': !curr});
                        setState(() {});
                      },
                      icon: Icon(Icons.delete_rounded, color: Colors.red),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
