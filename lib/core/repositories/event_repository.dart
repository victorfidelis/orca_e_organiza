import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:orca_e_organiza/core/repositories/repository.dart';
import 'package:orca_e_organiza/core/models/event_model.dart';

class EventRepository extends ChangeNotifier {

  List<EventModel> events = [];

  Future<bool> insert(EventModel eventModel) async {
    Database database = await Repository.getDataBase();

    String insert = 'INSERT INTO Events (name, date, start, end, theme) VALUES (?, ?, ?, ?, ?)';
    List params = [
      eventModel.name,
      eventModel.date?.millisecondsSinceEpoch ?? 0,
      eventModel.start,
      eventModel.end,
      eventModel.theme,
    ];
    int id = await database.rawInsert(insert, params);

    database.close();

    if (id > 0) {
      eventModel.id = id;
      events.add(eventModel);
    }

    notifyListeners();

    return (id > 0);
  }

  Future<bool> update(EventModel eventModel) async {
    Database database = await Repository.getDataBase();

    String update = ''
        'UPDATE Events '
        'SET '
          'name = ?, '
          'date = ?, '
          'start = ?, '
          'end = ?, '
          'theme = ? '
        'WHERE '
          'id = ?';

    List params = [
      eventModel.name,
      eventModel.date?.millisecondsSinceEpoch ?? 0,
      eventModel.start,
      eventModel.end,
      eventModel.theme,
      eventModel.id
    ];
    int updated = await database.rawUpdate(update, params);

    database.close();

    if (updated == 1) {
      events[events.indexWhere((element) => element.id == eventModel.id)] = eventModel;
    }

    notifyListeners();

    return (updated == 1);
  }

  Future<bool> delete(int id) async {
    Database database = await Repository.getDataBase();

    String budgetsDelete = ''
        'DELETE FROM Budgets '
          'WHERE Budgets.modalityId IN ( '
            'SELECT '
              'Modalities.id '
            'FROM '
              'Modalities '
            'WHERE Modalities.eventId = ? '
        ')';
    List budgetsParams = [id];
    int deleteBudgets = await database.rawDelete(budgetsDelete, budgetsParams);

    print(deleteBudgets);

    String modalitiesDelete = 'DELETE FROM Modalities WHERE eventId = ?';
    List modalitiesParams = [id];
    await database.rawDelete(modalitiesDelete, modalitiesParams);

    String delete = 'DELETE FROM Events WHERE id = ?';
    List params = [id];
    int deleted = await database.rawDelete(delete, params);

    database.close();

    if (deleted == 1) {
      events.removeWhere((element) => element.id == id);
    }

    notifyListeners();

    return (deleted == 1);
  }

  Future<void> select() async {
    Database database = await Repository.getDataBase();

    String select = ''
        'SELECT '
          'Events.id, '
          'Events.name, '
          'Events.date, '
          'Events.start, '
          'Events.end, '
          'Events.theme, '
          'Budget.cost '
        'FROM '
          'Events '
          'LEFT JOIN '
          '('
            'SELECT '
              'Modalities.eventId as eventId, '
              'SUM(Budgets.value) as cost '
            'FROM '
              'Modalities '
              'INNER JOIN Budgets ON Modalities.id = Budgets.modalityId AND Budgets.check_ = 1 '
            'GROUP BY '
              'Modalities.eventId '
          ') Budget ON Events.id = Budget.eventId';

    List<Map> listQuery = await database.rawQuery(select);

    database.close();

    List<EventModel> listEventModel = listQuery
        .map((e) => EventModel(
              id: e['id'],
              name: e['name'],
              date: e['date'] == 0
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(e['date']),
              start: e['start'],
              end: e['end'],
              theme: e['theme'],
              cost: e['cost'],
            ))
        .toList();

    notifyListeners();

    events = listEventModel;
  }

  void upgradeCost (int eventId, double cost) {
    events[events.indexWhere((element) => element.id == eventId)].cost = cost;
    notifyListeners();
  }
}
