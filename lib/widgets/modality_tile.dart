import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/modality_model.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/widgets/line_double_text.dart';
import 'package:orca_e_organiza/widgets/line_double_text_link.dart';
import 'package:orca_e_organiza/widgets/text_button_botton_sheet.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';

class ModalityTile extends StatefulWidget {
  final ModalityModel modalityModel;
  final Function(int, [bool]) openModality;
  final Function(int) editModality;
  final Function(int) deleteModality;
  final Function(String) openPage;
  final Function(String) openPhone;
  final int index;

  static bool isStart = true;

  ModalityTile({
    Key? key,
    required this.modalityModel,
    required this.openModality,
    required this.editModality,
    required this.deleteModality,
    required this.openPage,
    required this.openPhone,
    required this.index,
  }) : super(key: key);

  @override
  State<ModalityTile> createState() => _ModalityTileState();
}

class _ModalityTileState extends State<ModalityTile> {
  bool _animate = false;
  bool detail = false;

  bool showAddress = false;
  bool showPhone = false;
  bool showSite = false;
  bool showEmail = false;
  bool showDescription = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    if (ModalityTile.isStart) {
      int multiplier = widget.index <= 10 ? widget.index : 10;
      Future.delayed(Duration(milliseconds: multiplier * 100), () {
        setState(() {
          _animate = true;
          ModalityTile.isStart = false;
        });
      });
    } else {
      _animate = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    String modalityName = widget.modalityModel.name;
    String budgetName = widget.modalityModel.budgetModel?.name ?? '';
    String budgetValue = formatterMoney.format(widget.modalityModel.budgetModel?.value ?? 0.00);
    String budgetAddress = widget.modalityModel.budgetModel?.address ?? '';
    String budgetPhone = widget.modalityModel.budgetModel?.phone ?? '';
    String budgetSite = widget.modalityModel.budgetModel?.site ?? '';
    String budgetEmail = widget.modalityModel.budgetModel?.email ?? '';
    String budgetDescription = widget.modalityModel.budgetModel?.description ?? '';

    if (widget.modalityModel.budgetModel != null) {
      if (widget.modalityModel.budgetModel!.address.trim().isNotEmpty) showAddress = true;
      if (widget.modalityModel.budgetModel!.phone.trim().isNotEmpty) showPhone = true;
      if (widget.modalityModel.budgetModel!.site.trim().isNotEmpty) showSite = true;
      if (widget.modalityModel.budgetModel!.email.trim().isNotEmpty) showEmail = true;
      if (widget.modalityModel.budgetModel!.description.trim().isNotEmpty) showDescription = true;
    }

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
            widget.openModality(widget.index);
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
                            text: 'Abrir',
                            color: buttomPrimaryColor,
                            textColor: buttomTertiaryColor,
                            icon: Icon(Icons.file_open,
                                color: buttomTertiaryColor),
                            onPressed: () {
                              widget.openModality(widget.index, true);
                            },
                          ),
                          const SizedBox(height: 8),
                          TextButtonBottomSheet(
                            text: 'Editar',
                            color: buttomPrimaryColor,
                            textColor: buttomTertiaryColor,
                            icon: Icon(Icons.edit, color: buttomTertiaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                              widget.editModality(widget.index);
                            },
                          ),
                          const SizedBox(height: 8),
                          TextButtonBottomSheet(
                            text: 'Excluir',
                            color: buttomDeleteColor,
                            textColor: buttomDeleteTextColor,
                            icon: Icon(Icons.delete,
                                color: buttomDeleteTextColor),
                            onPressed: () {
                              widget.deleteModality(widget.index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColorCard,
            ),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: widget.modalityModel.budgetModel ==
                    null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modalityName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modalityName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LineDoubleText(label: 'Nome: ', value: budgetName),
                            const SizedBox(height: 8),
                            LineDoubleText(
                                label: 'Valor: ', value: 'R\$ $budgetValue'),
                            !detail
                                ? Container()
                                : Column(
                                    children: [
                                      showAddress ? const SizedBox(height: 8) : Container(),
                                      showAddress ? LineDoubleText(
                                          label: 'Endereço: ',
                                          value: budgetAddress,
                                      ) : Container(),
                                      showPhone ? const SizedBox(height: 8) : Container(),
                                      showPhone ? LineDoubleTextLink(
                                          label: 'Telefone: ',
                                          value: budgetPhone,
                                          openLink: widget.openPhone,
                                      ) : Container(),
                                      showSite ? const SizedBox(height: 8) : Container(),
                                      showSite ? LineDoubleTextLink(
                                        label: 'Site: ',
                                        value: budgetSite,
                                        openLink: widget.openPage,
                                      ) : Container(),
                                      showEmail ? const SizedBox(height: 8) : Container(),
                                      showEmail ? LineDoubleText(
                                        label: 'E-mail: ',
                                        value: budgetEmail,
                                      ) : Container(),
                                      showDescription ? const SizedBox(height: 8) : Container(),
                                      showDescription ? LineDoubleText(
                                        label: 'Descrição: ',
                                        value: budgetDescription.isEmpty
                                            ? ''
                                            : budgetDescription,
                                      ) : Container(),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            detail = !detail;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Icon(
                            detail
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
