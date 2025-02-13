import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primaryContainer,
                // ignore: deprecated_member_use
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text(
                  "Menu",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_month,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              "Plans",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 22),
            ),
            minTileHeight: 70,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.food_bank,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              "Aliments",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 22),
            ),
            minTileHeight: 70,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.bar_chart_sharp,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              "Statistiques",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 22),
            ),
            minTileHeight: 70,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.photo_camera,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              "Photos",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 22),
            ),
            minTileHeight: 70,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              "Paramètres",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 22),
            ),
            minTileHeight: 70,
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              "Déconnexion",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 22),
            ),
            minTileHeight: 70,
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
