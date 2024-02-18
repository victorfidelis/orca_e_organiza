import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orca_e_organiza/core/models/event_model.dart';
import 'package:orca_e_organiza/core/extensions/extensions.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';
import 'package:orca_e_organiza/widgets/text_button_botton_sheet.dart';

class EventTile extends StatefulWidget {
  final EventModel eventModel;
  final Function(EventModel, [bool]) openEvent;
  final Function(EventModel) editEvent;
  final Function(EventModel, int) deleteEvent;
  final int index;

  EventTile({
    Key? key,
    required this.eventModel,
    required this.openEvent,
    required this.editEvent,
    required this.deleteEvent,
    required this.index,
  }) : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool animationCard = false;

  @override
  void initState() {
    setState(() {
      animationCard = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String eventName = widget.eventModel.name;
    String eventCost = formatterMoney.format(widget.eventModel.cost ?? 0.00);
    String? eventDate;
    String? eventDayWeek;
    String? eventTheme = widget.eventModel.theme ??
        'assets/images/themes/theme_bg_01_default.png';
    String? daysToEvent;

    if (widget.eventModel.date != null) {
      DateTime eventDateTime = widget.eventModel.date!;

      eventDate = DateFormat('dd/MM/yyy').format(eventDateTime);
      eventDayWeek = DateFormat("EEEE", "pt_BR").format(eventDateTime).capitalize();

      if (DateTime.now().day == eventDateTime.day &&
          DateTime.now().month == eventDateTime.month &&
          DateTime.now().year == eventDateTime.year) {
        daysToEvent = 'Seu evento é hoje';
      } else if (eventDateTime.compareTo(DateTime.now()) > 0) {
        daysToEvent = 'Faltam ${eventDateTime.difference(DateTime.now()).inDays} dias';
      }
      else {
        daysToEvent = 'Evento já realizado';
      }
    }

    String? hour;
    if (widget.eventModel.start != null &&
        widget.eventModel.start!.trim().isNotEmpty &&
        widget.eventModel.end != null &&
        widget.eventModel.end!.trim().isNotEmpty) {
      hour =
          'Das ${widget.eventModel.start!.substring(0, 2)}:${widget.eventModel.start!.substring(2, 4)} às '
          '${widget.eventModel.end!.substring(0, 2)}:${widget.eventModel.end!.substring(2, 4)}';
    } else if (widget.eventModel.start != null &&
        widget.eventModel.start!.trim().isNotEmpty) {
      hour =
          'Início do evento: ${widget.eventModel.start!.substring(0, 2)}:${widget.eventModel.start!.substring(2, 4)}';
    } else if (widget.eventModel.end != null &&
        widget.eventModel.end!.trim().isNotEmpty) {
      hour =
          'Final do evento: ${widget.eventModel.end!.substring(0, 2)}:${widget.eventModel.end!.substring(2, 4)}';
    }

    return GestureDetector(
      onTap: () {
        widget.openEvent(widget.eventModel);
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
                              widget.openEvent(
                                widget.eventModel,
                                true,
                              );
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
                              widget.editEvent(widget.eventModel);
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
                              widget.deleteEvent(widget.eventModel, widget.index);
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
          image: DecorationImage(
                  opacity: 0.3,
                  image: AssetImage(
                    eventTheme,
                  ),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                eventName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: textPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eventDate == null
                        ? Container()
                        : Text(
                            '$eventDate (${eventDayWeek!})',
                            style: const TextStyle(fontSize: 14),
                          ),
                    hour == null
                        ? Container()
                        : Text(
                            hour,
                            style: const TextStyle(fontSize: 14),
                          ),
                    widget.eventModel.date == null
                        ? Container()
                        : const SizedBox(height: 8),
                    widget.eventModel.date == null
                        ? Container()
                        : Text(
                            daysToEvent ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ],
                ),
                Expanded(
                  child: Text(
                    'R\$ $eventCost',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
