import 'package:flutter/material.dart';
import 'package:letter_round/pages/credits_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:letter_round/widgets/confirmation_dialog.dart';
import 'package:letter_round/widgets/settings_card.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'bottom_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showDialog = false;
  bool _showDialogDelete = false;
  bool _showDialogDeleteConfirm = false;

  void _logout() {
    // Logique pour la déconnexion
    // setState pour gérer l'état de l'utilisateur, comme dans le code React Native
  }

  void _deleteAccount() {
    // Logique pour supprimer le compte
  }

  void _handleLogout() {
    setState(() {
      _showDialog = true;
    });
  }

  void _confirmLogout() {
    _logout();
    setState(() {
      _showDialog = false;
    });
  }

  void _cancelLogout() {
    setState(() {
      _showDialog = false;
    });
  }

  void _handleDeleteAccount() {
    setState(() {
      _showDialogDelete = true;
    });
  }

  void _confirmDelete() {
    setState(() {
      _showDialogDelete = false;
      _showDialogDeleteConfirm = true;
    });
  }

  void _confirmDeleteAgain() {
    _deleteAccount();
    setState(() {
      _showDialogDelete = false;
      _showDialogDeleteConfirm = false;
    });
  }

  void _cancelDelete() {
    setState(() {
      _showDialogDelete = false;
      _showDialogDeleteConfirm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: blackColor,
          elevation: 0,
          iconTheme: const IconThemeData(size: 32, color: whiteColor),
          title: Text(
            'Settings',
            style: TextStyle(
              color: whiteColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(CupertinoIcons.back, size: 32, color: whiteColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsCard(
                title: "Profil",
                icon: CupertinoIcons.person_fill,
                onPress: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomBar(initialIndex: 2),
                    ),
                  );
                },
              ),
              SettingsCard(
                title: "Crédits",
                icon: CupertinoIcons.info_circle_fill,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreditsPage()),
                  );
                },
              ),
              SettingsCard(
                title: "Language",
                icon: CupertinoIcons.globe,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreditsPage()),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Column(
                    spacing: 1,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                      Text(
                        '© 2025 LetterRound',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                      Text(
                        'Rights Reserved',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                      Text(
                        'Made in France',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Dialogs
        floatingActionButton:
            _showDialog
                ? ConfirmationDialog(
                  visible: _showDialog,
                  onConfirm: _confirmLogout,
                  onCancel: _cancelLogout,
                  title: 'Are you sure you want to log out?',
                )
                : _showDialogDelete
                ? ConfirmationDialog(
                  visible: _showDialogDelete,
                  onConfirm: _confirmDelete,
                  onCancel: _cancelDelete,
                  title: 'Are you sure you want to delete your account?',
                )
                : _showDialogDeleteConfirm
                ? ConfirmationDialog(
                  visible: _showDialogDeleteConfirm,
                  onConfirm: _confirmDeleteAgain,
                  onCancel: _cancelDelete,
                  title: 'This action is irreversible!',
                )
                : SizedBox.shrink(),
      ),
    );
  }
}
