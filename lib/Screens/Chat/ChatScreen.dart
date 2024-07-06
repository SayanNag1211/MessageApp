import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:smsq/Screens/Chat/bloc/chat_bloc.dart';
import 'package:smsq/const/Theme.dart';
import 'package:smsq/model/Message_model.dart';
// / import 'package:flutter/foundation.dart' as foundation;

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  String name;
  String email;
  ChatScreen({
    super.key,
    required this.name,
    required this.email,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    TextEditingController _chatcontroller = TextEditingController();
    ScrollController _scrollcontroller = ScrollController();
    void _sendsms() {
      if (_chatcontroller.text.isNotEmpty) {
        BlocProvider.of<ChatBloc>(context).add(
          SendEvent(message: _chatcontroller.value.text, to: email),
        );
        _chatcontroller.clear();
      }
    }

    void deleteMess() {
      BlocProvider.of<ChatBloc>(context).add(deleteMessageEvent(from: email));
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Navigator.pop(context);
        deleteMess();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff25292e),
          actions: [
            Container(
              // height: 110,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xff25292e),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);

                            deleteMess();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          )),
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://static1.colliderimages.com/wordpress/wp-content/uploads/2022/11/Feature%20Image-1.jpg'),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      Text(name, style: TextTh.profilestyle),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      deleteMess();
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  // final val =
                  //     state.message.isEmpty ? "ol" : state.message[0].text;
                  // print(val);
                  // print('=====>>>>>>${state.message.length}');
                  return GroupedListView<Message, DateTime>(
                    elements: state.message, //: [],
                    groupBy: (message) => DateTime(
                      message.date.year,
                      message.date.month,
                      message.date.day,
                    ),
                    groupHeaderBuilder: (Message message) =>
                        message.from != email
                            ? const SizedBox()
                            : SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    DateFormat.yMMMd().format(message.date),
                                    style: TextTh.timestyle,
                                  ),
                                ),
                              ),
                    itemBuilder: (context, message) {
                      // print('=====>>>>>>${state.message.length}');

                      // print('------->>> ${message.text.length}');

                      return message.from != email
                          ? const SizedBox()
                          : message.text.isNotEmpty
                              ? Align(
                                  alignment: message.myside
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: message.myside
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                                bottomLeft: Radius.circular(8))
                                            : const BorderRadius.only(
                                                topRight: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                                bottomLeft: Radius.circular(8)),
                                        color: !message.myside
                                            ? const Color(0xff25292e)
                                            : const Color(0xff7132cc),
                                      ),
                                      child: Text(
                                        message.text,
                                        style: TextTh.chatstyle,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox();
                    },
                    reverse: true,
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    order: GroupedListOrder.DESC,
                  );
                },
              ),
            ),
            Container(
              // height: 50,
              height: 68,
              color: Colors.transparent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                // ignore: deprecated_member_use
                // child: RawKeyboardListener(
                // focusNode: FocusNode(),
                // onKey: (RawKeyEvent e) {
                //   if (e is RawKeyDownEvent &&
                //       e.logicalKey == LogicalKeyboardKey.enter) {
                //     _sendsms();
                //   }
                // },
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (t) {
                          // print('Work $t');
                          _sendsms();
                        },
                        controller: _chatcontroller,
                        scrollController: _scrollcontroller,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white60,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: "Type your message",
                          hintStyle: TextTh.hintstyle,
                          fillColor: Color(0xff25292e),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            // borderSide: BorderSide(width: 1.w,color: Colors.white)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            // borderSide: BorderSide(color: Colors.white,width: 1.w),
                          ),
                          // prefixIcon: IconButton(
                          //     onPressed: () {
                          //       // BlocProvider.of<EmojiopenBloc>(context)
                          //       //     .add(EmojiopenEvent());
                          //     },
                          //     icon: const Icon(Icons.emoji_emotions_outlined,
                          //         color: Colors.white, size: 22)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CircleAvatar(
                      foregroundColor: Colors.black,
                      radius: 24,
                      backgroundColor: Color(0xff25292e),
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () => _sendsms(),
                          icon: const Icon(
                            Icons.send,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // BlocBuilder<EmojiopenBloc, EmojiopenState>(
            //   builder: (context, state) {
            //     print('""""""""" ${state.Emoji}');
            //     return Offstage(
            //       offstage: !state.Emoji,
            //       child: EmojiPicker(
            //         // onEmojiSelected: (Category category, Emoji emoji) {
            //         //     // Do something when emoji is tapped (optional)

            //         // },
            //         onBackspacePressed: () {
            //           // Do something when the user taps the backspace button (optional)
            //           // Set it to null to hide the Backspace-Button
            //         },
            //         scrollController: _scrollcontroller,
            //         textEditingController:
            //             _chatcontroller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
            //         config: Config(
            //           height: 256,
            //           emojiViewConfig: EmojiViewConfig(
            //             buttonMode: ButtonMode.CUPERTINO,
            //             backgroundColor: const Color(0xff25292e),
            //             emojiSizeMax: 28 *
            //                 (foundation.defaultTargetPlatform ==
            //                         TargetPlatform.iOS
            //                     ? 1.20
            //                     : 1.0),
            //           ),
            //           swapCategoryAndBottomBar: true,
            //           skinToneConfig: const SkinToneConfig(),
            //           categoryViewConfig: const CategoryViewConfig(
            //               backgroundColor: Color(0xff0c1014)),
            //           bottomActionBarConfig: const BottomActionBarConfig(
            //               buttonColor: Colors.transparent,
            //               backgroundColor: Color(0xff0c1014)),
            //           searchViewConfig: const SearchViewConfig(
            //               buttonColor: Colors.white,
            //               buttonIconColor: Colors.white,
            //               backgroundColor: Color(0xff0c1014)),
            //         ),
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
