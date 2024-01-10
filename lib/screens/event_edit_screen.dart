import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orca_e_organiza/core/models/event_model.dart';
import 'package:orca_e_organiza/core/models/theme_model.dart';
import 'package:orca_e_organiza/core/repositories/event_repository.dart';
import 'package:orca_e_organiza/core/repositories/themes_repository.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/screens/theme_screen.dart';
import 'package:orca_e_organiza/widgets/text_field_format.dart';
import 'package:orca_e_organiza/widgets/text_field_date_format.dart';
import 'package:orca_e_organiza/widgets/text_field_mask_format.dart';
import 'package:orca_e_organiza/widgets/text_buttom_format.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:orca_e_organiza/widgets/theme_button.dart';
import 'package:provider/provider.dart';

class EventEditScreen extends StatefulWidget {
  EventModel? event;
  Function addFunction;

  EventEditScreen({Key? key, this.event, required this.addFunction})
      : super(key: key);

  @override
  State<EventEditScreen> createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  late bool insert;
  late int indexAdd;
  late EventRepository eventRepository;
  ThemeModel? themeModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  MaskedTextController startController = MaskedTextController(mask: '00:00');
  MaskedTextController endController = MaskedTextController(mask: '00:00');

  String? nameError;
  String? dateError;
  String? startError;
  String? endError;

  void loadTheme() {
    List<ThemeModel> themeModelList = ThemesRepository().themes;

    for (ThemeModel theme in themeModelList) {
      if (theme.image == widget.event?.theme) {
        themeModel = theme;
        break;
      }
    }
  }

  void setTheme() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) {
          return ThemeScreen();
        },
      ),
    ).then(
      (value) {
        if (value == null) {
          return;
        }
        setState(() {
          themeModel = value;
        });
      },
    );
  }

  @override
  void initState() {

    if (widget.event != null) {

      insert = false;
      nameController.text = widget.event!.name;
      if (widget.event!.date != null) {
        dateController.text =
            DateFormat('dd/MM/yyyy').format(widget.event!.date!);
      }
      if (widget.event!.start != null) {
        startController.text = widget.event!.start!;
      }
      if (widget.event!.end != null) {
        endController.text = widget.event!.end!;
      }

      loadTheme();
    } else {
      insert = true;
      widget.event = EventModel(name: '');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    eventRepository = Provider.of<EventRepository>(context, listen: false);
    indexAdd = eventRepository.events.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.event!.name.isEmpty ? 'Novo Evento' : widget.event!.name),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraint){
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraint.maxHeight,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldFormat(
                        label: 'Nome do evento',
                        controller: nameController,
                        errorText: nameError,
                      ),
                      const SizedBox(height: 12),
                      TextFieldDateFormat(
                        label: 'Data',
                        controller: dateController,
                        errorText: dateError,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 64,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 10),
                              child: const Text('Das'),
                            ),
                          ),
                          Expanded(
                            child: TextFieldMaskFormat(
                              controller: startController,
                              errorText: startError,
                              isNumeric: true,
                            ),
                          ),
                          SizedBox(
                            height: 64,
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: const Text('às'),
                            ),
                          ),
                          Expanded(
                            child: TextFieldMaskFormat(
                              controller: endController,
                              errorText: endError,
                              isNumeric: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ThemeButton(
                        themeModel: themeModel,
                        setTheme: setTheme,
                      ),
                      Expanded(child: Container()),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextButtomFormat(
                              label: 'SALVAR',
                              onPressed: save,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void save() {
    String name = nameController.text.trim();
    String dateText = dateController.text.trim();
    DateTime? date;
    String start = startController.text.replaceAll(':', '').padRight(4, ' ');
    String end = endController.text.replaceAll(':', '').padRight(4, ' ');

    int? startHour;
    int? startMinute;
    int? endHour;
    int? endMinute;

    if (name.isEmpty) {
      setState(() {
        nameError = 'Necessário informar o nome do evento';
        dateError = null;
        startError = null;
        endError = null;
      });
      return;
    }

    if (start.isNotEmpty) {
      startHour = int.tryParse(start.substring(0, 2));
      startMinute = int.tryParse(start.substring(2, 4));
    }

    if (end.isNotEmpty) {
      endHour = int.tryParse(end.substring(0, 2));
      endMinute = int.tryParse(end.substring(2, 4));
    }

    if ((start.trim().isNotEmpty) &&
        (start.trim().length < 4 ||
            startHour == null ||
            startHour >= 24 ||
            startMinute == null ||
            startMinute >= 60)) {
      setState(() {
        nameError = null;
        dateError = null;
        startError = 'Horário inválido';
        endError = null;
      });

      return;
    }

    if ((end.trim().isNotEmpty) &&
        (end.trim().length < 4 ||
            endHour == null ||
            endHour >= 24 ||
            endMinute == null ||
            endMinute >= 60)) {
      setState(() {
        nameError = null;
        dateError = null;
        startError = null;
        endError = 'Horário inválido';
      });

      return;
    }

    if (dateText.isNotEmpty) {
      date = DateFormat('dd/MM/yyyy').parse(dateText);
    }

    setState(() {
      nameError = null;
      dateError = null;
      startError = null;
      endError = null;
    });

    widget.event!.name = name;
    widget.event!.date = date;
    widget.event!.start = start;
    widget.event!.end = end;
    widget.event!.theme = themeModel?.image;

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Salvar cadastro'),
      content: Text('Deseja salvar o evento "$name"?'),
      actions: [
        TextButton(
          child: const Text('Sim', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.pop(context);
            widget.event!
                .save(Provider.of<EventRepository>(context, listen: false))
                .then((value) {
              if (value) {
                UtilsService.showSnackBarFormat(
                    ScaffoldMessenger.of(context), 'Evento salvo com sucesso');
                if (insert) {
                  widget.addFunction(indexAdd);
                }
                Navigator.pop(context);
              } else {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Ocorreu uma falha ao salvar o evento');
              }
            });
          },
        ),
        TextButton(
          child: const Text('Não', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (builder) => alertDialog);
  }
}
