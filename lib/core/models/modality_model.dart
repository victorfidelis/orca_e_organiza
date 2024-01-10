import 'package:orca_e_organiza/core/repositories/modalities_repository.dart';
import 'package:orca_e_organiza/core/models/budget_model.dart';

class ModalityModel {
  int? id;
  int eventId;
  String name;
  BudgetModel? budgetModel;

  ModalityModel({
    this.id,
    required this.eventId,
    required this.name,
    this.budgetModel,
  });

  Future<bool> save (ModalitiesRepository modalitiesRepository) async {

    bool sucess;
    if (id == null) {
      sucess = await modalitiesRepository.insert(this);
    }
    else {
      sucess = await modalitiesRepository.update(this);
    }
    return sucess;
  }
}