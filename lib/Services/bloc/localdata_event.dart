// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'localdata_bloc.dart';

@immutable
sealed class LocaldataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LocaldataEventAdd extends LocaldataEvent {
  final String name;
  final String email;
  LocaldataEventAdd({
    required this.name,
    required this.email,
  });
  // final String pp;

  LocaldataEventAdd copyWith({
    String? name,
    String? email,
  }) {
    return LocaldataEventAdd(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [name, email];
}

class LocaldataFetchEvent extends LocaldataEvent {
  @override
  List<Object> get props => [];
}

class LocaldataDeleteEvent extends LocaldataEvent {
  final int id;
  LocaldataDeleteEvent({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}
