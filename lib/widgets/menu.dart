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
    return Drawer(
      width: 230,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                          fontSize: 30,
                        ),
                  ),
                ],
              ),
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
                  icon: Icons.person,
                  title: "Compte",
                  onTap: () => onSelectScreen("Compte"),
                ),
                buildMenuItem(context,
                    icon: Icons.calendar_month, title: "Plans"),
                buildMenuItem(context,
                    icon: Icons.food_bank, title: "Aliments"),
                buildMenuItem(context,
                    icon: Icons.bar_chart_sharp, title: "Statistiques"),
                buildMenuItem(context,
                    icon: Icons.photo_camera, title: "Photos"),
                buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: "Paramètres",
                  onTap: () => onSelectScreen("Paramètres"),
                ),
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
    );
  }
}
