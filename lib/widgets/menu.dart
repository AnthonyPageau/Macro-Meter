import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  Widget buildMenuItem(BuildContext context,
      {required IconData icon, required String title, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 40,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 22,
            ),
      ),
      minTileHeight: 60,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        width: 230,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Color.fromARGB(255, 17, 127, 112),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Center(child: Image.asset("assets/images/logo.png")),
              ),
              ListBody(
                children: [
                  buildMenuItem(
                    context,
                    icon: Icons.home,
                    title: "Accueil",
                    onTap: () => onSelectScreen("Accueil"),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.calendar_month,
                    title: "Journal",
                    onTap: () => onSelectScreen("Journal"),
                  ),
                  buildMenuItem(
                    context,
                    icon: Icons.person,
                    title: "Compte",
                    onTap: () => onSelectScreen("Compte"),
                  ),
                  buildMenuItem(context,
                      icon: Icons.my_library_books_sharp,
                      title: "Plans",
                      onTap: () => onSelectScreen("Plans")),
                  buildMenuItem(context,
                      icon: Icons.food_bank,
                      title: "Aliments",
                      onTap: () => onSelectScreen("Aliment")),
                  buildMenuItem(context,
                      icon: Icons.play_circle_fill,
                      title: "Guide",
                      onTap: () => onSelectScreen("Guide")),
                  buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: "Déconnexion",
                    onTap: () => FirebaseAuth.instance.signOut(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
