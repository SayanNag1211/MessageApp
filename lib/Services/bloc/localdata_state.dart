// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'localdata_bloc.dart';

enum LocalStatus { initial, succes, failed }

class LocaldataState extends Equatable {
  final LocalStatus status;
  final List<User> user;
  const LocaldataState({
    this.status = LocalStatus.initial,
    this.user = const <User>[],
  });

  LocaldataState copyWith({
    LocalStatus? status,
    List<User>? user,
  }) {
    return LocaldataState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [status, user];
}
