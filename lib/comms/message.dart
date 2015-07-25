library comms.message;

import 'dart:convert';

class Message {
  // message types
  static const String INIT = "INIT";              // player initiative total message
  static const String GET_INIT = "GET_INIT";              // DM requesting initiative totals

  String senderUsername;    // null indicates server
  String charName;          // character this message applies to
  String type;
  var payload;

  Message(String this.senderUsername, String this.charName, String this.type, this.payload) {
    // messages created this way are outgoing, so payloads will be converted to a JSON-compatible form

    if (payload != null) {
      // if payload is a complex object or a List, JSON encode it
      if (payload is! String && payload is! num && payload is! bool && payload is! Map && payload is! List) {
        payload = payload.toMap();
      }

      if (payload is Map || payload is List) {
        payload = JSON.encode(payload);
      }
    }
  }

  Message.fromJSON(String str) {
    // messages created this way are incoming, so the payload should be decoded (if necessary)

    Map map = JSON.decode(str);

    senderUsername = map['senderUsername'];
    charName = map['charName'];
    type = map['type'];

    try{
      payload = JSON.decode(map['payload']);
    }
    catch (exc) {
      payload = map['payload'];
    }
  }

  String toJSON() {
    // this method expects any complex payloads to be encoded already

    return JSON.encode({
      'senderUsername': senderUsername,
      'charName': charName,
      'type': type,
      'payload': payload
    });
  }

  @override String toString() => "From: $senderUsername ($charName) -- Type: $type -- Payload: <${payload.runtimeType}>$payload";
}