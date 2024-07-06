// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  final String text;
  final String from;
  final bool myside;
  DateTime date;
  
  Message({
    required this.text,
    required this.from,
    this.myside = false,
    required this.date,
  });
}
