import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/budget_model.dart';
import 'package:orca_e_organiza/core/repositories/budgets_repository.dart';
import 'package:orca_e_organiza/core/repositories/event_repository.dart';
import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/core/themes/themes.dart';
import 'package:orca_e_organiza/screens/budget_edit_screen.dart';
import 'package:orca_e_organiza/widgets/budget_tile.dart';
import 'package:orca_e_organiza/widgets/text_buttom_format.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BudgetScreen extends StatefulWidget {
  BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late BudgetsRepository budgetsRepository;
  late ModalitiesRepository modalitiesRepository;
  late EventRepository eventsRepository;
  bool loading = false;

  final _myListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    setState(() {
      loading = true;
    });

    budgetsRepository = Provider.of<BudgetsRepository>(context, listen: false);
    modalitiesRepository =
        Provider.of<ModalitiesRepository>(context, listen: false);
    eventsRepository = Provider.of<EventRepository>(context, listen: false);

    budgetsRepository.select().then((value) {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  void editBudget(int index) {
    Navigator.push(
      context,
      PageTransition(
        child: BudgetEditScreen(
          budget: budgetsRepository.budgets[index],
          addItem: _addItem,
        ),
        type: PageTransitionType.bottomToTop,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void deleteBudget(int index) {
    BudgetModel budgetModel = budgetsRepository.budgets[index];

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Excluir orçamento'),
      content: Text(
          'Tem certeza que deseja excluir o orçamento "${budgetModel.name}"?'),
      actions: [
        TextButton(
          child: const Text('Sim', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            budgetsRepository.delete(budgetModel.id!).then((value) {
              if (value) {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Orçamento excluido com sucesso');
                _removeItem(budgetModel, index);
                if (budgetModel.check) {
                  setState(() {
                    upgradeScreens(index, true);
                  });
                }
              } else {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Ocorreu uma falha ao excluir o orçamento');
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

  void upgradeScreens(int index, [bool delete = false]) {
    setState(() {
      modalitiesRepository.updateBudget(
          budgetsRepository.budgets[index], delete);
      eventsRepository.upgradeCost(
        modalitiesRepository.eventModel!.id!,
        modalitiesRepository.sumBudgets(),
      );
    });
  }

  void checkBudget(int index, bool? checkChange) {
    bool currentCheck = budgetsRepository.budgets[index].check;
    budgetsRepository.budgets[index].check = checkChange ?? currentCheck;

    budgetsRepository.budgets[index]
        .changeCheck(budgetsRepository)
        .then((value) {
      if (!value) {
        UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
            'Ocorreu uma falha ao alterar o status do orçamento');
      } else {
        upgradeScreens(index);
      }
    });
  }

  void _addItem(int index) {
    _myListKey.currentState!.insertItem(
      index,
      duration: const Duration(milliseconds: 600),
    );
  }

  void _removeItem(BudgetModel budgetModel, int index) {
    _myListKey.currentState!.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Column(
            children: [
              BudgetTile(
                budgetModel: budgetModel,
                editBudget: editBudget,
                deleteBudget: deleteBudget,
                upgradeScreens: upgradeScreens,
                checkBudget: checkBudget,
                openPage: openPage,
                openPhone: openPhone,
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

  Future<void> openPage(String link) async {
    final Uri url = Uri.parse(link);
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
    return PopScope(
      onPopInvoked: (value) {
        BudgetTile.isStart = true;
      },
      child: Scaffold(
        body: Container(
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          SizedBox(
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
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                              left: 46,
                              top: 20,
                              right: 46,
                              bottom: 10,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    budgetsRepository.modalityModel!.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Lista de orçamentos',
                                  style: TextStyle(fontSize: 18),
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
                              child: Consumer<BudgetsRepository>(
                                builder: (context, budgetsRepository, child) {
                                  return AnimatedList(
                                    key: _myListKey,
                                    padding: EdgeInsets.zero,
                                    initialItemCount:
                                        budgetsRepository.budgets.length,
                                    itemBuilder: (context, index, animation) {
                                      return SizeTransition(
                                        sizeFactor: animation,
                                        child: Column(
                                          children: [
                                            BudgetTile(
                                              budgetModel: budgetsRepository
                                                  .budgets[index],
                                              editBudget: editBudget,
                                              deleteBudget: deleteBudget,
                                              upgradeScreens: upgradeScreens,
                                              checkBudget: checkBudget,
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
                                    label: 'NOVO ORÇAMENTO',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: BudgetEditScreen(
                                            addItem: _addItem,
                                          ),
                                          type: PageTransitionType.bottomToTop,
                                          curve: Curves.easeInOut,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          reverseDuration:
                                              const Duration(milliseconds: 400),
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
    );
  }
}
