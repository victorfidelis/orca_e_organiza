import 'package:flutter/material.dart';
import 'package:orca_e_organiza/core/repositories/repository.dart';
import 'package:orca_e_organiza/core/models/modality_model.dart';
import 'package:orca_e_organiza/core/models/budget_model.dart';
import 'package:sqflite/sqflite.dart';

class BudgetsRepository extends ChangeNotifier {
  List<BudgetModel> budgets = [];
  ModalityModel? modalityModel;

  Future<bool> insert(BudgetModel budgetModel) async {
    Database database = await Repository.getDataBase();

    String insert =
        'INSERT INTO Budgets ('
          'modalityId, '
          'name, '
          'value, '
          'description, '
          'check_, '
          'address,'
          'phone) VALUES (?, ?, ?, ?, ?, ?, ?)';
    List params = [
      budgetModel.modalityId,
      budgetModel.name,
      budgetModel.value,
      budgetModel.description,
      budgetModel.check,
      budgetModel.address,
      budgetModel.phone,
    ];
    int id = await database.rawInsert(insert, params);

    database.close();

    if (id > 0) {
      budgetModel.id = id;
      budgets.add(budgetModel);
    }

    notifyListeners();

    return (id > 0);
  }

  Future<bool> update(BudgetModel budgetModel) async {
    Database database = await Repository.getDataBase();

    String update = ''
        'UPDATE Budgets '
        'SET '
        'name = ?, '
        'value = ?, '
        'description = ?, '
        'check_ = ?, '
        'address = ?, '
        'phone = ? '
        'WHERE '
        'id = ?';

    List params = [
      budgetModel.name,
      budgetModel.value,
      budgetModel.description,
      budgetModel.check,
      budgetModel.address,
      budgetModel.phone,
      budgetModel.id,
    ];
    int updated = await database.rawUpdate(update, params);

    database.close();

    if (updated == 1) {
      budgets[budgets.indexWhere((element) => element.id == budgetModel.id)] =
          budgetModel;
    }

    notifyListeners();

    return (updated == 1);
  }

  Future<bool> updateCheck(BudgetModel budgetModel) async {
    Database database = await Repository.getDataBase();

    String update = '';
    List params = [];

    if (budgetModel.check) {
      update = ''
          'UPDATE Budgets '
          'SET '
          'check_ = CASE WHEN id = ? THEN 1 ELSE 0 END '
          'WHERE '
          'modalityId = ?';

      params = [
        budgetModel.id,
        budgetModel.modalityId,
      ];
    } else {
      update = ''
          'UPDATE Budgets '
          'SET '
          'check_ = 0 '
          'WHERE '
          'id = ?';

      params = [
        budgetModel.id,
      ];
    }

    int updated = await database.rawUpdate(update, params);

    database.close();

    if (updated > 0 && budgetModel.check) {
      List<BudgetModel> budgetsChange = budgets
          .where((element) => element.modalityId == budgetModel.modalityId)
          .toList();

      for (BudgetModel budgetChange in budgetsChange) {
        if (budgetChange.id == budgetModel.id) {
          budgets[budgets.indexWhere(
              (element) => element.id == budgetModel.id)] = budgetModel;
        } else {
          budgetChange.check = false;
          budgets[budgets.indexWhere(
              (element) => element.id == budgetChange.id)] = budgetChange;
        }
      }
    } else if (updated > 0) {
      budgets[budgets.indexWhere(
              (element) => element.id == budgetModel.id)] = budgetModel;
    }

    notifyListeners();

    return (updated > 0);
  }

  Future<bool> delete(int id) async {
    Database database = await Repository.getDataBase();

    String delete = 'DELETE FROM Budgets WHERE id = ?';
    List params = [id];
    int deleted = await database.rawDelete(delete, params);

    database.close();

    if (deleted == 1) {
      budgets.removeWhere((element) => element.id == id);
    }

    notifyListeners();

    return (deleted == 1);
  }

  Future<void> select() async {
    Database database = await Repository.getDataBase();

    String select =
        'SELECT '
          'id, '
          'modalityId, '
          'name, '
          'value, '
          'description, '
          'check_, '
          'address, '
          'phone '
        'FROM Budgets '
        'WHERE modalityId = ?';
    List params = [modalityModel?.id];
    List<Map> listQuery = await database.rawQuery(select, params);

    database.close();

    List<BudgetModel> listBudgetsModel = listQuery
        .map((e) => BudgetModel(
              id: e['id'],
              modalityId: e['modalityId'],
              name: e['name'],
              value: e['value'],
              description: e['description'],
              check: e['check_'] == 1 ? true : false,
              address: e['address'] ?? '',
              phone: e['phone'] ?? '',
            ))
        .toList();

    notifyListeners();

    budgets = listBudgetsModel;
  }
}
