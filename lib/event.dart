import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:collection/collection.dart' show IterableEquality;
import 'package:flutter/material.dart' show IconData, Icons;

/// Launch method for EventContact
enum LaunchMethod { CALL, MESSAGE, WEB, FACEBOOK }

enum NotificationType { ADD_FLAG, REM_FLAG, ALARM, CHANGE, REMOVE, ADD }

/// Hold Event Organizer Contact Data
class EventContact {
  Map<LaunchMethod, List> _methodToPropertyMap = {
    LaunchMethod.CALL: [Icons.call, (v) => "tel:$v", "Call"],
    LaunchMethod.MESSAGE: [Icons.call, (v) => "sms:$v", "Message"],
    LaunchMethod.WEB: [Icons.web, (v) => "$v", "Website"],
    LaunchMethod.FACEBOOK: [Icons.web, (v) => "$v", "Facebook"],
  };

  Map<String, LaunchMethod> _stringToMethodMap = {
    "CALL": LaunchMethod.CALL,
    "MESSAGE": LaunchMethod.MESSAGE,
    "WEB": LaunchMethod.WEB,
    "FACEBOOK": LaunchMethod.FACEBOOK
  };

  String contactPerson;
  String contactLink;
  LaunchMethod method;

  /// Get Icon according to launch method
  IconData getIcon() => _methodToPropertyMap[this.method][0];

  /// Get Url to execute the method
  String getUrl() => _methodToPropertyMap[this.method][1];

  /// Get String according to contact method
  String getContactMethodString() => _methodToPropertyMap[this.method][2];

  EventContact(this.contactPerson, this.contactLink, this.method);

  EventContact.fromList(List<String> contact) {
    this.contactLink = contact[1];
    this.contactPerson = contact[0];
    this.method = _stringToMethodMap[contact[2]];
  }
}

/// Class to hold info on events
/// Will be used as main object to save, load, show info
class Event {
  final String eventName;
  final String organizer;
  final String startTimeString;
  final String endTimeString;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final List<String> images;
  final String headerImage; // Auto assigned
  final String description;
  final String location;
  final String id;
  //List<EventContact> contact = [];
  final List<String> tags = [];

  Event(
      this.eventName,
      this.organizer,
      this.startTime,
      this.endTime,
      this.startTimeString,
      this.endTimeString,
      this.isAllDay,
      this.images,
      this.headerImage,
      this.description,
      this.location,
      this.id);

  factory Event.fromFirestoreDoc(DocumentSnapshot doc) {
    return new Event(
        doc.data['eventName'],
        doc.data['organizer'],
        doc.data['start'],
        doc.data['end'],
        getFormattedDate(doc.data['start'], doc.data['isAllDay']),
        getFormattedDate(doc.data['end'], doc.data['isAllDay']),
        doc.data['isAllDay'],
        List<String>.from(doc.data['images']),
        doc.data['images'][0],
        doc.data['description'],
        doc.data['location'],
        doc.documentID);
  }

  // Format Date to string
  static String getFormattedDate(DateTime obj, bool isAllDay) {
    String str = "";
    List<String> months = ['Jan', 'Feb', 'March', 'April', 'May', 'June',
    'July', 'Aug', 'Sep','Oct', 'Nov', 'Dec'];
    str += '${obj.year} ${months[obj.month]} ${obj.day} ';
    if (!isAllDay) 
     str += 'at ${(obj.hour % 12)}:${obj.minute.toString().padRight(2,'0')} ${obj.hour/12 == 0 ? "AM" : "PM"}';
    return str;
  }

  /// Create an event for test purposes
  /*
    TODO: Add functionality later in web
    for (List<String> _contact in eventData[7]) {
      this.contact.add(
            new EventContact.fromList(_contact),
          );
    }

    this.tags.add("Test");
    this.tags.add("Event");
    */
  /// Find if 2 events have same objects (Content)
  bool similar(Event other) {
    // Event name cannot change, but include here for the sako of consitancy
    return other.description == this.description &&
        other.startTime == this.startTime &&
        other.endTime == this.endTime &&
        other.isAllDay == this.isAllDay &&
        IterableEquality()
            .equals(other.images, this.images) && // Checking for list equality
        other.location == this.location &&
        other.organizer == this.organizer &&
        other.eventName == this.eventName &&
        other.id == this.id;
  }
}

class EventNotification {
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool read = false;

  EventNotification(this.message, this.type, this.timestamp);

  void markAsRead() {
    read = true;
  }

  IconData getIcon() {
    switch (this.type) {
      case NotificationType.ADD_FLAG:
        return Icons.flag;
      case NotificationType.REM_FLAG:
        return Icons.outlined_flag;
      case NotificationType.ALARM:
        return Icons.alarm;
      case NotificationType.CHANGE:
        return Icons.edit;
      case NotificationType.REMOVE:
        return Icons.remove;
      case NotificationType.ADD:
        return Icons.add;
      default:
        return Icons.info;
    }
  }
}

class FlaggedEvent {
  final String eventID;
  final bool alarmStatus;

  FlaggedEvent(this.eventID, this.alarmStatus);
}
