import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orca_e_organiza/core/extensions/extensions.dart';
import 'package:orca_e_organiza/core/models/modality_model.dart';
import 'package:orca_e_organiza/core/repositories/budgets_repository.dart';
import 'package:orca_e_organiza/core/repositories/event_repository.dart';
import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';
import 'package:orca_e_organiza/screens/budget_screen.dart';
import 'package:orca_e_organiza/screens/modality_edit_screen.dart';
import 'package:orca_e_organiza/widgets/modality_tile.dart';
import 'package:orca_e_organiza/widgets/text_buttom_format.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ModalityScreen extends StatefulWidget {
  ModalityScreen({Key? key}) : super(key: key);

  @override
  State<ModalityScreen> createState() => _ModalityScreenState();
}

class _ModalityScreenState extends State<ModalityScreen> {
  static bool runBudgetScreen = false;
  bool loading = false;
  late EventRepository eventsRepository;
  late ModalitiesRepository modalitiesRepository;
  final _myListKey = GlobalKey<AnimatedListState>();

  String? eventDate;
  String? eventDayWeek;
  String? daysToEvent;

  @override
  void initState() {
    eventsRepository = Provider.of<EventRepository>(context, listen: false);
    modalitiesRepository =
        Provider.of<ModalitiesRepository>(context, listen: false);

    if (!runBudgetScreen) {
      setState(() {
        loading = true;
      });

      modalitiesRepository.select().then((value) {
        setState(() {
          loading = false;
        });
      });
    }

    super.initState();
  }

  void openModality(int index, [bool fromMenu = false]) {
    BudgetsRepository budgetsRepository =
        Provider.of<BudgetsRepository>(context, listen: false);
    budgetsRepository.modalityModel = modalitiesRepository.modalities[index];

    runBudgetScreen = true;

    Navigator.push(
      context,
      PageTransition(
        child: BudgetScreen(),
        type: PageTransitionType.rightToLeftJoined,
        childCurrent: widget,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      ),
    ).then((value) {
      runBudgetScreen = false;
      if (fromMenu) Navigator.pop(context);
    });
  }

  void editModality(int index) {
    Navigator.push(
      context,
      PageTransition(
        child: ModalityEditScreen(
          modality: modalitiesRepository.modalities[index],
          addItem: _addItem,
        ),
        type: PageTransitionType.bottomToTop,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void deleteModality(int index) {
    ModalityModel modalityModel = modalitiesRepository.modalities[index];
    AlertDialog alertDialog = AlertDialog(
      title: const Text('Excluir modalidade'),
      content: Text(
          'Tem certeza que deseja excluir a modalidade "${modalityModel.name}"?'),
      actions: [
        TextButton(
          child: const Text('Sim', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            modalitiesRepository
                .delete(modalitiesRepository.modalities[index].id!)
                .then((value) {
              if (value) {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Modalidade excluida com sucesso');
                _removeItem(modalityModel, index);
                eventsRepository.upgradeCost(
                  modalitiesRepository.eventModel!.id!,
                  modalitiesRepository.sumBudgets(),
                );
              } else {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Ocorreu uma falha ao excluir a modalidade');
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

  void _removeItem(ModalityModel modalityModel, int index) {
    _myListKey.currentState!.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Column(
            children: [
              ModalityTile(
                modalityModel: modalityModel,
                openModality: (int _, [bool __ = false]) {},
                editModality: (int _) {},
                deleteModality: (int _) {},
                openPage: openPage,
                openPhone: openPhone,
                index: 0,
              ),
              const Divider(),
            ],
          ),
        );
      },
      duration: const Duration(milliseconds: 400),
    );
  }

  Future<void> openPage(String link) async {
    final Uri url = Uri.parse(link);
    bool success = false;
    try {
      success = await launchUrl(url);
    } on Exception catch (e) {
      success = false;
    }

    if (!success) {
      UtilsService.showSnackBarFormat(
        ScaffoldMessenger.of(context),
        'Ocorreu uma falha ao acessar o link.',
      );
    }
  }

  Future<void> openPhone(String phone) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phone,
    );
    bool success = false;
    try {
      success = await launchUrl(url);
    } on Exception catch (e) {
      print(e);
      success = false;
    }

    if (!success) {
      UtilsService.showSnackBarFormat(
        ScaffoldMessenger.of(context),
        'Ocorreu uma falha ao efetuar ligação.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (modalitiesRepository.eventModel?.date != null) {
      DateTime eventDateTime = modalitiesRepository.eventModel!.date!;

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

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        onPopInvoked: (value) {
          if (runBudgetScreen) {
            return;
          }
          ModalityTile.isStart = true;
        },
        child: Scaffold(
          body: Container(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            modalitiesRepository.eventModel!.theme == null ||
                                    modalitiesRepository
                                        .eventModel!.theme!.isEmpty
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                      'assets/images/themes/theme_bg_01_default.png',
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Opacity(
                                      opacity: 0.3,
                                      child: Image.asset(
                                        modalitiesRepository.eventModel!.theme!,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                            Container(
                              margin: const EdgeInsets.only(left: 5, top: 30),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  alignment: Alignment.topLeft,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              alignment: eventDate == null
                                  ? Alignment.center
                                  : Alignment.bottomCenter,
                              padding: const EdgeInsets.only(
                                left: 46,
                                top: 40,
                                right: 46,
                                bottom: 10,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      modalitiesRepository.eventModel!.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Consumer<ModalitiesRepository>(
                                    builder:
                                        (context, modalitiesRepository, child) {
                                      return Text(
                                        'R\$ ${formatterMoney.format(modalitiesRepository.sumBudgets())}',
                                        style: const TextStyle(fontSize: 22),
                                      );
                                    },
                                  ),
                                  eventDate == null
                                      ? Container()
                                      : Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              '${eventDate!} (${eventDayWeek!})',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              daysToEvent!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: backgroundPrimaryColor,
                        thickness: 4,
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            top: 4,
                            right: 10,
                            bottom: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Consumer<ModalitiesRepository>(
                                  builder:
                                      (context, modalitiesRepository, child) {
                                    return AnimatedList(
                                      key: _myListKey,
                                      padding: EdgeInsets.zero,
                                      initialItemCount: modalitiesRepository
                                          .modalities.length,
                                      itemBuilder: (context, index, animation) {
                                        return SizeTransition(
                                          sizeFactor: animation,
                                          child: Column(
                                            children: [
                                              ModalityTile(
                                                modalityModel:
                                                    modalitiesRepository
                                                        .modalities[index],
                                                openModality: openModality,
                                                editModality: editModality,
                                                deleteModality: deleteModality,
                                                openPage: openPage,
                                                openPhone: openPhone,
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
                                      label: 'NOVA MODALIDADE',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: ModalityEditScreen(
                                              addItem: _addItem,
                                            ),
                                            type: PageTransitionType.bottomToTop,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(milliseconds: 400),
                                            reverseDuration: const Duration(milliseconds: 400),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
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
