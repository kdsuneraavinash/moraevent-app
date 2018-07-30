import 'package:flutter/material.dart';
import 'package:event_app/state/flagged.dart';
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_flagged/event_flagged_card.dart'
    show EventFlaggedCard;
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;

/// Window to show pinned events to toggle alarms
/// TODO: Add notifications on Alarm times
class FlaggedEventManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pinned Events"),
      ),
      body: StoreConnector<EventStore, EventStore>(
        converter: (store) => store.state,
        builder: (context, eventStore) =>
            buildAlarmButtons(eventStore.flaggedList),
      ),
    );
  }

  Widget buildAlarmButtons(List<FlaggedEvent> alarmList) {
    List<Widget> list = [];
    for (FlaggedEvent alarm in alarmList) {
      list.add(EventFlaggedCard(alarm));
    }

    if (list.isEmpty) {
      return Center(child: Text("Pin events and they will show up here."));
    } else {
      return ListView.builder(
        itemBuilder: (_, index) => list[index],
        itemCount: list.length,
      );
    }
  }
}
