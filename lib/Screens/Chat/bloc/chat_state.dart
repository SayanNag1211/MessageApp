// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
class ChatState extends Equatable {
  final String from;
  final bool online;
  final int index;
  final List<Message> message;

  const ChatState({
    this.from = '',
    this.online = false,
    this.index = 0,
    this.message = const <Message>[],
  });

  ChatState copyWith({
    String? from,
    bool? online,
    int? index,
    List<Message>? message,
  }) {
    return ChatState(
      from: from ?? this.from,
      online: online ?? this.online,
      index: index ?? this.index,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [message, from, online];
}
