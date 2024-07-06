import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'emojiopen_event.dart';
part 'emojiopen_state.dart';

class EmojiopenBloc extends Bloc<EmojiopenEvent, EmojiopenState> {
  EmojiopenBloc() : super(EmojiopenState()) {
    on<EmojiopenEvent>((event, emit) {
      emit(state.copyWith(state.Emoji = !state.Emoji));
      // print('%%%$state.Emoji');
    });
  }
}
