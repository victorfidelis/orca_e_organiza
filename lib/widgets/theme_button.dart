import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/theme_model.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';
import 'package:orca_e_organiza/screens/theme_screen.dart';

class ThemeButton extends StatefulWidget {
  ThemeModel? themeModel;
  Function() setTheme;

  ThemeButton({this.themeModel, required this.setTheme, Key? key})
      : super(key: key);

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Tema do evento: ',
              textAlign: TextAlign.left,
            ),
            const SizedBox(width: 4),
            Text(
              widget.themeModel?.name ?? '',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: widget.setTheme,
                child: Container(
                  height: 180,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundColorCard,
                    image: DecorationImage(
                      opacity: 0.8,
                      image: AssetImage(
                        widget.themeModel?.image ??
                            'assets/images/themes/theme_bg_01_default.png',
                      ),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter,
                    ),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Center(
                      child: widget.themeModel == null
                          ? const Text(
                              'Toque para escolher um tema para o seu evento',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            )
                          : Container()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
