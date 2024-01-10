import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/budget_model.dart';
import 'package:orca_e_organiza/core/repositories/budgets_repository.dart';
import 'package:orca_e_organiza/core/repositories/event_repository.dart';
import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/widgets/text_buttom_format.dart';
import 'package:orca_e_organiza/widgets/text_field_edit_format.dart';
import 'package:orca_e_organiza/widgets/text_field_format.dart';
import 'package:orca_e_organiza/widgets/text_field_money_format.dart';
import 'package:orca_e_organiza/widgets/text_field_phone_format.dart';
import 'package:provider/provider.dart';

class BudgetEditScreen extends StatefulWidget {
  BudgetModel? budget;
  Function addItem;

  BudgetEditScreen({Key? key, this.budget, required this.addItem}) : super(key: key);

  @override
  State<BudgetEditScreen> createState() => _BudgetEditScreenState();
}

class _BudgetEditScreenState extends State<BudgetEditScreen> {
  late bool insert;
  late int indexAdd;
  late BudgetsRepository budgetsRepository;
  late ModalitiesRepository modalitiesRepository;
  late EventRepository eventsRepository;
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  MaskedTextController phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController descriptionController = TextEditingController();

  String? nameError;
  String? valueError;
  String? descriptionError;

  @override
  void initState() {
    budgetsRepository = Provider.of<BudgetsRepository>(context, listen: false);
    modalitiesRepository =
        Provider.of<ModalitiesRepository>(context, listen: false);
    eventsRepository = Provider.of<EventRepository>(context, listen: false);
    if (widget.budget != null) {
      insert = false;
      nameController.text = widget.budget!.name;
      valueController.text = formatterMoney.format(widget.budget!.value);
      addressController.text = widget.budget!.address;
      phoneController.text = widget.budget!.phone;
      descriptionController.text = widget.budget!.description;
    } else {
      insert = true;
      widget.budget = BudgetModel(
        modalityId: budgetsRepository.modalityModel!.id!,
        name: '',
        value: 0,
        description: '',
        check: false,
        address: '',
        phone: '',
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    indexAdd = budgetsRepository.budgets.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget!.name.isEmpty
            ? 'Novo Orçamento'
            : widget.budget!.name),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraint) {
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
                    children: [
                      TextFieldFormat(
                        label: 'Nome do orçamento',
                        controller: nameController,
                        errorText: nameError,
                      ),
                      const SizedBox(height: 12),
                      TextFieldMoneyFormat(
                        label: 'Valor',
                        controller: valueController,
                        errorText: valueError,
                      ),
                      const SizedBox(height: 12),
                      TextFieldFormat(
                        label: 'Endereço',
                        controller: addressController,
                      ),
                      const SizedBox(height: 12),
                      TextFieldPhoneFormat(
                        label: 'Contato',
                        controller: phoneController,
                      ),
                      const SizedBox(height: 12),
                      TextFieldEditFormat(
                        label: 'Descrição',
                        controller: descriptionController,
                        errorText: descriptionError,
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
            )
          );
        },
      ),
    );
  }

  void save() {
    String name = nameController.text.trim();

    String valueString = valueController.text.trim();
    if (valueString.isEmpty) valueString = '0';
    double? valueDouble =
        double.tryParse(valueString.replaceAll('.', '').replaceAll(',', '.'));
    if (valueDouble == null) {
      setState(() {
        valueError = 'Valor incorreto';
      });
      return;
    }
    valueError = null;

    String address = addressController.text.trim();
    String phone = phoneController.text.trim();
    String description = descriptionController.text.trim();

    if (name.isEmpty) {
      setState(() {
        nameError = 'Necessário informar o nome do orçamento';
      });
      return;
    }

    setState(() {
      nameError = null;
    });

    widget.budget!.name = name;
    widget.budget!.value = valueDouble;
    widget.budget!.address = address;
    widget.budget!.phone = phone;
    widget.budget!.description = description;

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Salvar cadastro'),
      content: Text('Deseja salvar o orçamento "$name"?'),
      actions: [
        TextButton(
          child: const Text('Sim', style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.pop(context);

            widget.budget!.save(budgetsRepository).then((value) {
              if (value) {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Orçamento salvo com sucesso');

                if (widget.budget!.check) {
                  modalitiesRepository.updateBudget(widget.budget!);

                  int eventId = modalitiesRepository
                      .currentModality(widget.budget!.modalityId)
                      .eventId;
                  eventsRepository.upgradeCost(
                    eventId,
                    modalitiesRepository.sumBudgets(),
                  );
                }

                if (insert) {
                  widget.addItem(indexAdd);
                }

                Navigator.pop(context);
              } else {
                UtilsService.showSnackBarFormat(ScaffoldMessenger.of(context),
                    'Ocorreu uma falha ao salvar o orçamento');
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
