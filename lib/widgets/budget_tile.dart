import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/budget_model.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/widgets/line_double_text.dart';
import 'package:orca_e_organiza/widgets/text_button_botton_sheet.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';

class BudgetTile extends StatefulWidget {
  BudgetModel budgetModel;
  Function(int) editBudget;
  Function(int) deleteBudget;
  Function(int, [bool]) upgradeScreens;
  Function(int, bool?) checkBudget;
  int index;

  static bool isStart = true;

  BudgetTile({
    Key? key,
    required this.budgetModel,
    required this.editBudget,
    required this.deleteBudget,
    required this.upgradeScreens,
    required this.checkBudget,
    required this.index,
  }) : super(key: key);

  @override
  State<BudgetTile> createState() => _BudgetTileState();
}

class _BudgetTileState extends State<BudgetTile> {
  bool _animate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (BudgetTile.isStart) {
      int multiplier = widget.index <= 10 ? widget.index : 10;
      Future.delayed(Duration(milliseconds: multiplier * 100), () {
        setState(() {
          _animate = true;
          BudgetTile.isStart = false;
        });
      });
    } else {
      _animate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOut,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 600),
        padding: _animate
            ? const EdgeInsets.only(left: 0)
            : const EdgeInsets.only(left: 150),
        child: GestureDetector(
          onTap: () {
            widget.editBudget(widget.index);
          },
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                ),
                builder: (builder) {
                  return BottomSheet(
                      onClosing: () {},
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButtonBottomSheet(
                                text: 'Editar',
                                color: buttomPrimaryColor,
                                textColor: buttomTertiaryColor,
                                icon: Icon(Icons.edit, color: buttomTertiaryColor),
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.editBudget(widget.index);
                                },
                              ),
                              const SizedBox(height: 8),
                              TextButtonBottomSheet(
                                text: 'Excluir',
                                color: buttomDeleteColor,
                                textColor: buttomDeleteTextColor,
                                icon: Icon(Icons.delete, color: buttomDeleteTextColor),
                                onPressed: () {
                                  widget.deleteBudget(widget.index);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                });
          },
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColorCard,
            ),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.budgetModel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 8),
                          LineDoubleText(
                            label: 'Valor: ',
                            value:
                                'R\$ ${formatterMoney.format(widget.budgetModel.value)}',
                          ),
                          const SizedBox(height: 8),
                          LineDoubleText(
                            label: 'Endereço: ',
                            value: widget.budgetModel.address,
                          ),
                          const SizedBox(height: 8),
                          LineDoubleText(
                            label: 'Telefone: ',
                            value: widget.budgetModel.phone,
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: widget.budgetModel.check,
                      onChanged: (checkChange) {
                        widget.checkBudget(widget.index, checkChange);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 8),
                LineDoubleText(
                  label: 'Descrição: ',
                  value: widget.budgetModel.description,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
