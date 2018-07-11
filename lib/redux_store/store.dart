import 'package:event_app/event.dart' show Event, EventNotification, FlaggedEvent;
import 'package:event_app/test_data.dart' show events;

/// The main store object
class EventStore {
  final List<Event> eventList;
  final List<FlaggedEvent> flaggedList;
  final List<EventNotification> notifications;
  final Event currentSelectedEvent;

  static EventStore loadEventStore() {
    return EventStore(
      events.map((v) => Event.fromDataList(v)).toList(),
      List(),
      null,
      List(),
    );
  }

  EventStore(this.eventList, this.flaggedList, this.currentSelectedEvent,
      this.notifications);
}
