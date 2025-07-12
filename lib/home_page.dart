import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reciepe_app2/favourite_page.dart';
import 'package:reciepe_app2/main_menu_screen.dart';
import 'package:reciepe_app2/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> listPages =[
    MainMenuScreen(),
    FavouritePage(),
    FavouritePage(),
    FavouritePage(),
  ];
  int selected = 0;
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
      body: listPages[selected],
    );
  }
}
