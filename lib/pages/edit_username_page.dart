import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';

class EditUsernamePage extends StatefulWidget {
  final String currentUsername;

  const EditUsernamePage({super.key, required this.currentUsername});

  @override
  _EditUsernamePageState createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentUsername);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveAndReturn() {
    String newUsername = _controller.text.trim();
    if (newUsername.isNotEmpty) {
      Navigator.pop(context, newUsername);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.isDarkMode ? backgroundColor : whiteColor,
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode
                ? blackColor
                : greyColor.withValues(alpha: 0.3),
        elevation: 0,
        iconTheme: IconThemeData(
          size: 32,
          color: themeProvider.isDarkMode ? whiteColor : blackColor,
        ),
        title: Text(
          'Modifier le username',
          style: TextStyle(
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(CupertinoIcons.back, size: 32),
                onPressed: () {
                  _saveAndReturn();
                },
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18),
                hintText: "Nouveau username",
                hintStyle: TextStyle(
                  color:
                      themeProvider.isDarkMode
                          ? greyColor
                          : greyColor.withValues(alpha: 0.35),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.pencil,
                  color:
                      themeProvider.isDarkMode
                          ? greyColor
                          : greyColor.withValues(alpha: 0.35),
                ),
                filled: true,
                fillColor:
                    themeProvider.isDarkMode
                        ? greyColor.withValues(alpha: 0.25)
                        : greyColor.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveAndReturn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                backgroundColor: blue,
                foregroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Enregistrer",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
