import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smsq/Services/bloc/localdata_bloc.dart';
import 'package:smsq/Services/localDatabase.dart';
import 'package:smsq/model/LocalData_model.dart';
import 'package:smsq/model/Message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<SendEvent>(_sendMsg);
    on<RecivedEvent>(_recived);

    on<OnlineEvent>(_onlinecheck);
    on<NewUseraddEvent>(_newUseradd);
    on<UpdateMessageEvent>((event, emit) {
      emit(
        state.copyWith(
          message: List.unmodifiable([...state.message, event.newMessage]),
        ),
      );
    });
    on<deleteMessageEvent>((event, emit) {
      final List<Message> updatedMessages = List.unmodifiable([]);
      // List<Message> mg = [];
      // mg.clear();
      if (state.from == event.from) {
        emit(
          state.copyWith(
            message: updatedMessages,
          ),
        );
      } else {
        return;
      }
    });
  }

  late IO.Socket socket;

  Future _recived(RecivedEvent event, Emitter<ChatState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ServerUrl = dotenv.env['SERVER_URL'];
    try {
      socket = IO.io(ServerUrl, <String, dynamic>{
        "transports": ["websocket"],
      });
      socket.on(
          'connect',
          (_) => {
                socket.emit('register', prefs.getString('E-mail')),
                debugPrint('Connected to server'),
              });
      socket.on('disconnect', (_) => debugPrint('Disconnected from server'));
      socket.on('error', (data) => debugPrint('Error: $data'));
      // print('YEs');
      late String msg;
      late Message rnewMessage;
      socket.on('Client1', (m) async {
        final from = m['from'];
        final message = m['message'];
        debugPrint('Server1: $message - $from');
        msg = message;
        // if (m['form'] == event.from) {
        //   print('====::${event.from}');
        // }
        add(OnlineEvent(to: from));

        rnewMessage = Message(
          text: msg.toString(),
          myside: false,
          date: DateTime.now(),
          from: m['from'].toString(),
        );

        add(UpdateMessageEvent(rnewMessage));
        // String name = from.substring(0, from.indexOf('@'));
        // add(NewUseraddEvent(email: from, name: name, context: event.context));
      });
    } catch (e) {
      print(e);
    }
  }

  Future _sendMsg(SendEvent event, Emitter<ChatState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print(event.to);
      socket.emit('Server1', {
        'to': event.to,
        'message': event.message,
        'from': prefs.getString('E-mail'),
      });
      final newMessage = Message(
        text: event.message,
        myside: true,
        date: DateTime.now(),
        from: event.to,
      );
      emit(
        state.copyWith(
          message: List.unmodifiable([...state.message, newMessage]),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  final dbHelper = DatabaseHelper();

  Future<void> _onlinecheck(OnlineEvent event, Emitter<ChatState> emit) async {
    List<User> users = await dbHelper.fetchUsers();
    int i;
    for (i = 0; i <= users.length; i++) {
      if (users[i].email == event.to) {
        // print('-----------"""${users[i].email}');
        emit(state.copyWith(online: true, index: i));
      }
    }
  }

  Future _newUseradd(NewUseraddEvent event, Emitter<ChatState> emit) async {
    try {
      // bool dbExist = await dbHelper.doesDatabaseExist();
      List<User> users = await dbHelper.fetchUsers();
      User user =
          User(name: event.name, email: event.email, profilePicture: '/');
      for (int i = 0; i <= users.length; i++) {
        if (users[i].email == event.email) {
          return;
          // break;
        } else {
          await dbHelper.database;
          dbHelper.insertUser(user);
          // BlocProvider.of<LocaldataBloc>(event.context)
          //     .add(LocaldataFetchEvent());
          // LocaldataFetchEvent();
          // add(RecivedEvent());
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      // emit(state.copyWith(status: LocalStatus.failed));
    }
  }
}
