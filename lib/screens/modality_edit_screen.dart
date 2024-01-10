import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/modality_model.dart';
import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/core/services/utils_service.dart';
import 'package:orca_e_organiza/widgets/text_buttom_format.dart';
import 'package:orca_e_organiza/widgets/text_field_format.dart';
import 'package:provider/provider.dart';

class ModalityEditScreen extends StatefulWidget {
  ModalityModel? modality;
  Function addItem;

  ModalityEditScreen({Key? key, this.modality, required this.addItem}) : super(key: key);

  @override
  State<ModalityEditScreen> createState() => _ModalityEditScreenState();
}

class _ModalityEditScreenState extends State<ModalityEditScreen> {
  late bool insert;
  late int indexAdd;
  late ModalitiesRepository modalitiesRepository;
  TextEditingController nameController = TextEditingController();
  String? nameError;

  @override
  void initState() {
    modalitiesRepository =
        Provider.of<ModalitiesRepository>(context, listen: false);
    if (widget.modality != null) {
      insert = false;
      nameController.text = widget.modality!.name;
    } else {
      insert = true;
      widget.modality = ModalityModel(
          name: '', eventId: modalitiesRepository.eventModel!.id!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    indexAdd = modalitiesRepository.modalities.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.modality!.name.isEmpty ? 'Nova Modalidade' : widget.modality!.name),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          children: [
            TextFieldFormat(
              label: 'Nome da modalidade',
              controller: nameController,
              errorText: nameError,
            ),
            Expanded(child: Container()),
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
    );
  }


  void save() {
    String name = nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        nameError = 'Necessário informar o nome do evento';
      });
      return;
    }

    setState(() {
      nameError = null;
    });

    widget.modality!.name = name;

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Salvar cadastro'),
      content: Text('Deseja salvar a modalidade "$name"?'),
      actions: [
        TextButton(
          child: const Text('Sim', style: TextStyle(color: Colors.green)),
          onPressed: (){
            Navigator.pop(context);

            widget.modality!.save(modalitiesRepository).then((value) {
              if (value) {
                UtilsService.showSnackBarFormat(
                    ScaffoldMessenger.of(context), 'Modalidade salva com sucesso');
                if (insert) {
                  widget.addItem(indexAdd);
                }
                Navigator.pop(context);
              } else {
                UtilsService.showSnackBarFormat(
                    ScaffoldMessenger.of(context), 'Ocorreu uma falha ao salvar a modalidade');
              }
            });
          },
        ),
        TextButton(
          child: const Text('Não', style: TextStyle(color: Colors.red)),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (builder) => alertDialog);
  }
}


