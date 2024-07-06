import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smsq/Services/localDatabase.dart';
import 'package:smsq/model/LocalData_model.dart';

part 'localdata_event.dart';
part 'localdata_state.dart';

class LocaldataBloc extends Bloc<LocaldataEvent, LocaldataState> {
  LocaldataBloc() : super(const LocaldataState()) {
    on<LocaldataEventAdd>(_addData);
    on<LocaldataFetchEvent>(_fetchData);
    on<LocaldataDeleteEvent>(_deleteData);
  }
  final dbHelper = DatabaseHelper();
  Future<void> _addData(
      LocaldataEventAdd event, Emitter<LocaldataState> emit) async {
    emit(state.copyWith(status: LocalStatus.initial));
    try {
      bool dbExist = await dbHelper.doesDatabaseExist();
      User user =
          User(name: event.name, email: event.email, profilePicture: '/');
      if (dbExist) {
        dbHelper.insertUser(user);
        emit(state.copyWith(
          status: LocalStatus.succes,
        ));
        add(LocaldataFetchEvent());
      } else {
        await dbHelper.database;
        dbHelper.insertUser(user);
        emit(state.copyWith(
          status: LocalStatus.succes,
        ));
        add(LocaldataFetchEvent());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: LocalStatus.failed));
    }
  }

  Future<void> _fetchData(
      LocaldataFetchEvent event, Emitter<LocaldataState> emit) async {
    List<User> users = await dbHelper.fetchUsers();
    emit(state.copyWith(status: LocalStatus.initial));
    try {
      emit(state.copyWith(status: LocalStatus.succes, user: users));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: LocalStatus.failed));
    }
  }

  Future<void> _deleteData(
      LocaldataDeleteEvent event, Emitter<LocaldataState> emit) async {
    emit(state.copyWith(status: LocalStatus.initial));
    try {
      await dbHelper.deleteUser(event.id);
      add(LocaldataFetchEvent());
      emit(state.copyWith(status: LocalStatus.succes));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: LocalStatus.failed));
    }
  }
}
