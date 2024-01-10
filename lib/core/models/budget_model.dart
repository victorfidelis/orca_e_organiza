import 'package:orca_e_organiza/core/repositories/budgets_repository.dart';

class BudgetModel {
  int? id;
  int modalityId;
  String name;
  double value;
  String description;
  bool check;
  String address;
  String phone;

  BudgetModel({
    this.id,
    required this.modalityId,
    required this.name,
    required this.value,
    required this.description,
    required this.check,
    required this.address,
    required this.phone,
  });

  Future<bool> save (BudgetsRepository budgetsRepository) async {

    bool sucess;
    if (id == null) {
      sucess = await budgetsRepository.insert(this);
    }
    else {
      sucess = await budgetsRepository.update(this);
    }
    return sucess;
  }

  Future<bool> changeCheck(BudgetsRepository budgetsRepository) async {
    return await budgetsRepository.updateCheck(this);
  }
}