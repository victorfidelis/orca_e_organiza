import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/theme_model.dart';
import 'package:orca_e_organiza/core/repositories/themes_repository.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/widgets/text_buttom_format.dart';

class ThemeScreen extends StatefulWidget {
  ThemeScreen({Key? key}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  List<ThemeModel> themeModelList = ThemesRepository().themes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temas'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: themeModelList.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          bool check = !themeModelList[index].check;
                          themeModelList = themeModelList
                              .map((e) =>
                                  ThemeModel(image: e.image, name: e.name))
                              .toList();
                          themeModelList[index].check = check;
                        });
                      },
                      child: Stack(
                        children: [
                          themeModelList[index].check
                              ? Container(
                                  alignment: Alignment.topRight,
                                  margin:
                                      const EdgeInsets.only(top: 6, right: 6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: themeModelList[index].check
                                    ? Colors.green
                                    : Colors.grey,
                                width: themeModelList[index].check ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  themeModelList[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 180,
                                    minHeight: 50,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          themeModelList[index].image,
                                        ),
                                        fit: BoxFit.fitWidth,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    child: Center(child: Container()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButtomFormat(
                    label: 'CONFIRMAR TEMA',
                    onPressed: () {
                      ThemeModel? themeModel;
                      for (ThemeModel theme in themeModelList) {
                        if (theme.check) {
                          themeModel = theme;
                          break;
                        }
                      }

                      if (themeModel == null) {
                        UtilsService.showSnackBarFormat(
                          ScaffoldMessenger.of(context),
                          'Nenhum tema foi selecionado.',
                        );
                        return;
                      }

                      Navigator.pop(
                        context,
                        themeModel,
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
