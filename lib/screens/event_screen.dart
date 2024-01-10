import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/event_model.dart';
import 'package:orca_e_organiza/core/repositories/event_repository.dart';
import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';
import 'package:orca_e_organiza/screens/event_edit_screen.dart';
import 'package:orca_e_organiza/screens/modality_screen.dart';
import 'package:orca_e_organiza/widgets/event_tile.dart';
import 'package:orca_e_organiza/widgets/text_buttom_format.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool loading = false;
  static bool _isStart = true;
  final _myListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    if (_isStart) {
      setState(() {
        loading = true;
      });

      Provider.of<EventRepository>(context, listen: false)
          .select()
          .then((value) {
        setState(() {
          loading = false;
          _isStart = false;
        });
      });
    }

    super.initState();
  }

  void openEvent(EventModel eventModel, [bool fromMenu = false]) {
    ModalitiesRepository modalitiesRepository =
        Provider.of<ModalitiesRepository>(context, listen: false);
    modalitiesRepository.eventModel = eventModel;

    Navigator.push(
      context,
      PageTransition(
        child: ModalityScreen(),
        type: PageTransitionType.rightToLeftJoined,
        childCurrent: widget,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      ),
    ).then((value) {
      if (fromMenu) Navigator.pop(context);
    });
  }

  void editEvent(EventModel eventModel) {
    Navigator.push(
      context,
      PageTransition(
        child: EventEditScreen(
          event: eventModel,
          addFunction: () {},
        ),
        type: PageTransitionType.bottomToTop,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void deleteEvent(EventModel eventModel, int index) {
    EventRepository eventRepository =
        Provider.of<EventRepository>(context, listen: false);
    int index = eventRepository.events.indexWhere((e) => e.id == eventModel.id);

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Excluir evento'),
      content:
          Text('Tem certeza que deseja excluir o evento "${eventModel.name}"?'),
      actions: [
        TextButton(
          child: const Text('Sim', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            eventRepository.delete(eventModel.id!).then((value) {
              if (value) {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Evento excluido com sucesso');
                _removeItem(eventModel, index);
              } else {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Ocorreu uma falha ao excluir o evento');
              }
            });
          },
        ),
        TextButton(
          child: const Text('Não', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (builder) => alertDialog);
  }

  void _addItem(int index) {
    _myListKey.currentState!.insertItem(
      index,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _removeItem(EventModel eventModel, int index) {
    _myListKey.currentState!.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Column(
            children: [
              EventTile(
                eventModel: eventModel,
                openEvent: openEvent,
                editEvent: editEvent,
                deleteEvent: deleteEvent,
                index: index,
              ),
              const Divider(),
            ],
          ),
        );
      },
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundPrimaryColor,
        automaticallyImplyLeading: false,
        title: AnimatedOpacity(
          opacity: _isStart ? 0 : 1,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 1500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Orça&Organiza',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: backgroundTertiaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: backgroundPrimaryColor,
        child: Stack(
          children: [
            AnimatedPositioned(
              left: 0,
              top: _isStart ? 600 : 0,
              right: 0,
              bottom: 0,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 800),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: backgroundColorDefault,
                ),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 12, top: 8),
                              child: const Text(
                                'Meus eventos',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: Consumer<EventRepository>(
                                builder: (context, eventRepository, child) {
                                  eventRepository.events.sort((a, b) {
                                    if ((a.date == null && b.date == null) ||
                                        (a.date == b.date)) {
                                      return a.name.compareTo(b.name);
                                    } else if (a.date == null) {
                                      return 1;
                                    } else if (b.date == null) {
                                      return -1;
                                    } else {
                                      return a.date!.compareTo(b.date!);
                                    }
                                  });

                                  return AnimatedList(
                                    key: _myListKey,
                                    initialItemCount:
                                        eventRepository.events.length,
                                    itemBuilder: (context, index, animation) {
                                      return SizeTransition(
                                        sizeFactor: animation,
                                        child: Column(
                                          children: [
                                            EventTile(
                                              eventModel:
                                                  eventRepository.events[index],
                                              openEvent: openEvent,
                                              editEvent: editEvent,
                                              deleteEvent: deleteEvent,
                                              index: index,
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButtomFormat(
                                    label: 'NOVO EVENTO',
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(
                                            PageTransition(
                                              child: EventEditScreen(
                                                addFunction: _addItem,
                                              ),
                                              type: PageTransitionType.bottomToTop,
                                              curve: Curves.easeInOut,
                                              duration: const Duration(milliseconds: 400),
                                              reverseDuration: const Duration(milliseconds: 400),
                                            ),
                                          ).then((value) => null);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
