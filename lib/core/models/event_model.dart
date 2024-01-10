
import 'package:orca_e_organiza/core/repositories/event_repository.dart';

class EventModel {
  int? id;
  String name;
  DateTime? date;
  String? start;
  String? end;
  String? theme;
  double? cost;

  EventModel({
    this.id,
    required this.name,
    this.date,
    this.start,
    this.end,
    this.theme,
    this.cost,
  });

  Future<bool> save (EventRepository eventRepository) async {
    bool sucess;
    if (id == null) {
      sucess = await eventRepository.insert(this);
    }
    else {
      sucess = await eventRepository.update(this);
    }
    return sucess;
  }
}
