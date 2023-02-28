// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "change": MessageLookupByLibrary.simpleMessage("Switch"),
        "changeFailure":
            MessageLookupByLibrary.simpleMessage("Failed to switch"),
        "changed": MessageLookupByLibrary.simpleMessage("Switched"),
        "close": MessageLookupByLibrary.simpleMessage("close"),
        "closed": MessageLookupByLibrary.simpleMessage("Closed"),
        "closedFailure": MessageLookupByLibrary.simpleMessage("Closed failure"),
        "confirm": MessageLookupByLibrary.simpleMessage("confirm"),
        "connected": MessageLookupByLibrary.simpleMessage("Connected"),
        "exit": MessageLookupByLibrary.simpleMessage("exit"),
        "fetched": MessageLookupByLibrary.simpleMessage("nodes are ready"),
        "fetching":
            MessageLookupByLibrary.simpleMessage("Fetching nodes from server"),
        "inputEmpty":
            MessageLookupByLibrary.simpleMessage("The input cannt be empty"),
        "inputFormatWrong":
            MessageLookupByLibrary.simpleMessage("The input format is wrong"),
        "launch": MessageLookupByLibrary.simpleMessage("launch"),
        "node": MessageLookupByLibrary.simpleMessage("node"),
        "proxyInitFailure":
            MessageLookupByLibrary.simpleMessage("Failed to start proxy"),
        "proxyInitSuccess":
            MessageLookupByLibrary.simpleMessage("Start proxy successfully"),
        "serverAddress": MessageLookupByLibrary.simpleMessage("server address"),
        "setting": MessageLookupByLibrary.simpleMessage("setting"),
        "started": MessageLookupByLibrary.simpleMessage("Started"),
        "starting": MessageLookupByLibrary.simpleMessage("Starting"),
        "userId": MessageLookupByLibrary.simpleMessage("user id")
      };
}
