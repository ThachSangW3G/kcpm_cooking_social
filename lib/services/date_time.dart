import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

Duration calculateElapsedTime(Timestamp timestamp) {
  DateTime currentTime = DateTime.now();
  DateTime timestampTime = timestamp.toDate();
  Duration difference = currentTime.difference(timestampTime);
  return difference;
}

String calculateTimeDifference(DateTime startTime, DateTime endTime) {
  Duration difference = endTime.difference(startTime);
  DateTime now = DateTime.now();
  DateTime adjustedStartTime = now.subtract(difference);

  return timeago.format(adjustedStartTime);
}

String calculateTimeAgo(DateTime dateTime) {
  DateTime now = DateTime.now();
  return timeago.format(now.subtract(now.difference(dateTime)));
}
