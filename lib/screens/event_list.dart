import 'package:flutter/material.dart';

import 'package:event_app/screens/credits.dart' show Credits;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/screens/event_list/event_list_body.dart'
    show EventListBody;

/// Main Page that displays a list of available Events.
/// TODO: Implement a action element in AppBar => PopupMenuButton
class EventListWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mora Events"),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.search),
            onPressed: () => _handleSearchAction(context),
          ),
          IconButton(
            icon: new Icon(Icons.help),
            onPressed: () => _handleCreditsAction(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "Mora Events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              subtitle: Text("View latest event notifications"),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Pinned Events"),
              subtitle: Text("Show events that you pinned"),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text("Alarms"),
              subtitle: Text("Show future alarms"),
              onTap: () => null,
            ),
          ],
        ),
      ),
      body: EventListBody(),
    );
  }

  void _handleCreditsAction(BuildContext context) {
    TransitionMaker
        .slideTransition(
          destinationPageCall: () => Credits(),
        )
        .start(context);
  }

  void _handleSearchAction(BuildContext context) {}
}
