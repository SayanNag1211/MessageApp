// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'emojiopen_bloc.dart';

// ignore: must_be_immutable
class EmojiopenState extends Equatable {
  bool Emoji;
  EmojiopenState({
    this.Emoji = false,
  });

  EmojiopenState copyWith(
    bool bool, {
    bool? Emoji,
  }) {
    return EmojiopenState(
      Emoji: Emoji ?? this.Emoji,
    );
  }

  @override
  List<Object?> get props => [Emoji];
}
