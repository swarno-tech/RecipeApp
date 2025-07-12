import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ShowFood extends StatefulWidget {
  const ShowFood({super.key});

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
        elevation: 1,
        onPressed: () {},
        label: Row(
          children: [
            ElevatedButton(onPressed: (){}, child: Text("Start Cooking",style: TextStyle(color: Colors.white),)),
            IconButton(onPressed: () {}, icon: Icon(Iconsax.heart))],
        ),
      ),
    );
  }
}
