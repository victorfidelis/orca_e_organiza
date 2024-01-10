import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/models/budget_model.dart';
import 'package:orca_e_organiza/core/models/event_model.dart';
import 'package:orca_e_organiza/core/repositories/repository.dart';
import 'package:orca_e_organiza/core/models/modality_model.dart';
import 'package:sqflite/sqflite.dart';

class ModalitiesRepository extends ChangeNotifier {
  List<ModalityModel> modalities = [];
  EventModel? eventModel;

  Future<bool> insert(ModalityModel modalityModel) async {
    Database database = await Repository.getDataBase();

    String insert = 'INSERT INTO Modalities (eventId, name) VALUES (?, ?)';
    List params = [
      modalityModel.eventId,
      modalityModel.name,
    ];
    int id = await database.rawInsert(insert, params);

    database.close();

    if (id > 0) {
      modalityModel.id = id;
      modalities.add(modalityModel);
    }

    notifyListeners();

    return (id > 0);
  }

  Future<bool> update(ModalityModel modalityModel) async {
    Database database = await Repository.getDataBase();

    String update = ''
        'UPDATE Modalities '
        'SET '
        'name = ? '
        'WHERE '
        'id = ?';

    List params = [
      modalityModel.name,
      modalityModel.id,
    ];
    int updated = await database.rawUpdate(update, params);

    database.close();

    if (updated == 1) {
      modalities[modalities.indexWhere(
          (element) => element.id == modalityModel.id)] = modalityModel;
    }

    notifyListeners();

    return (updated == 1);
  }

  Future<bool> delete(int id) async {
    Database database = await Repository.getDataBase();

    String budgetsDelete = 'DELETE FROM Budgets WHERE modalityId = ?';
    List budgetsParams = [id];
    await database.rawDelete(budgetsDelete, budgetsParams);

    String delete = 'DELETE FROM Modalities WHERE id = ?';
    List params = [id];
    int deleted = await database.rawDelete(delete, params);

    database.close();

    if (deleted == 1) {
      modalities.removeWhere((element) => element.id == id);
    }

    notifyListeners();

    return (deleted == 1);
  }

  Future<void> select() async {
    Database database = await Repository.getDataBase();

    String select = ''
        'SELECT '
        'Modalities.id, '
        'Modalities.eventId, '
        'Modalities.name ,'
        'Budgets.id as budgetId, '
        'Budgets.name as budgetName, '
        'Budgets.value as budgetvalue, '
        'Budgets.description as budgetDescription, '
        'Budgets.check_ as budgetCheck, '
        'Budgets.address as budgetAddress, '
        'Budgets.phone as budgetPhone '
        'FROM '
        'Modalities '
        'LEFT JOIN Budgets ON Modalities.id = Budgets.modalityId AND Budgets.check_ = 1 '
        'WHERE Modalities.eventId = ?';

    List params = [eventModel?.id];
    List<Map> listQuery = await database.rawQuery(select, params);

    database.close();

    List<ModalityModel> listModalitiesModel = listQuery.map((e) {
      BudgetModel? budgetModel;

      if (e['budgetId'] != null && e['budgetId'] > 0) {
        budgetModel = BudgetModel(
          id: e['budgetId'],
          modalityId: e['id'],
          name: e['budgetName'],
          value: e['budgetvalue'],
          description: e['budgetDescription'],
          check: e['budgetCheck'] == 1,
          address: e['budgetAddress'] ?? '',
          phone: e['budgetPhone'] ?? '',
        );
      }

      return ModalityModel(
        id: e['id'],
        eventId: e['eventId'],
        name: e['name'],
        budgetModel: budgetModel,
      );
    }).toList();

    notifyListeners();

    modalities = listModalitiesModel;
  }

  void updateBudget(BudgetModel budgetModel, [bool delete = false]) {
    BudgetModel? currentBudget;
    if (budgetModel.check) currentBudget = budgetModel;

    modalities[modalities.indexWhere((e) => e.id == budgetModel.modalityId)]
        .budgetModel = delete ? null : currentBudget;
    notifyListeners();
  }

  ModalityModel currentModality(int modalityId){
    return modalities[modalities.indexWhere((e) => e.id == modalityId)];
  }

  double sumBudgets() {
    List<double> listBudgets = modalities.map((e) => e.budgetModel?.value ?? 0).toList();
    if (listBudgets.length == 0) return 0;
    return listBudgets.reduce((value, element) => value + element);
  }
}
