// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendEvent extends ChatEvent {
  final String to;
  final String message;
  SendEvent({
    required this.to,
    required this.message,
  });
  @override
  List<Object> get props => [message, to];
}

class RecivedEvent extends ChatEvent {
 
  @override
  List<Object> get props => [];
}

class OnlineEvent extends ChatEvent {
  final String to;
  OnlineEvent({
    required this.to,
  });
  @override
  List<Object> get props => [to];
}

class UpdateMessageEvent extends ChatEvent {
  final Message newMessage;

  UpdateMessageEvent(this.newMessage);
  @override
  List<Object> get props => [newMessage];
}

class deleteMessageEvent extends ChatEvent {
  final String from;
  deleteMessageEvent({
    required this.from,
  });

  deleteMessageEvent copyWith({
    String? from,
  }) {
    return deleteMessageEvent(
      from: from ?? this.from,
    );
  }

  @override
  List<Object> get props => [from];
}

class NewUseraddEvent extends ChatEvent {

  final String name;
  final String email;
  NewUseraddEvent({
    required this.name,
    required this.email,
  });

  NewUseraddEvent copyWith({
    String? name,
    String? email,
  }) {
    return NewUseraddEvent(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [name, email];
}
