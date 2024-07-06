// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smsq/Screens/Chat/ChatScreen.dart';
import 'package:smsq/Screens/Chat/bloc/chat_bloc.dart';

import 'package:smsq/Screens/LoginScreen.dart';
import 'package:smsq/const/Theme.dart';

import '../Services/bloc/localdata_bloc.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  SharedPreferences prefs;
  HomeScreen({
    super.key,
    required this.prefs,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late String from;
  @override
  void initState() {
    BlocProvider.of<LocaldataBloc>(context).add(LocaldataFetchEvent());
    BlocProvider.of<ChatBloc>(context).add(RecivedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchcontroller = TextEditingController();
    void Logout() async {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('X-token');

      // ignore: use_build_context_synchronously
      navigateToTop(context, const Loginscreen());
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const Loginscreen(),
      //     ),
      //     (route) => false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Go-Message',
          style: TextTh.logstyle,
        ),
        actions: [
          PopupMenuTheme(
            data: Theme.of(context).popupMenuTheme.copyWith(
                  color: Color(0xff25292e),
                  iconColor: Colors.white,
                  // shape: Be,
                ),
            child: PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: InkWell(
                    onTap: () {
                      // print("=======ddd");
                    },
                    child: Row(
                      children: [
                        widget.prefs.getString('P-photo')!.isNotEmpty
                            ? CircleAvatar(
                                radius: 15,
                                backgroundImage: NetworkImage(
                                    widget.prefs.getString('P-photo')!),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          widget.prefs.getString('USer-name')!,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextTh.chatstyle,
                        ),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: InkWell(
                    onTap: () => Logout(),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Log-out',
                          style: TextTh.chatstyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            TextField(
              onSubmitted: (t) {},
              controller: searchcontroller,
              style: const TextStyle(
                color: Colors.white,
              ),
              cursorColor: Colors.white60,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextTh.hintstyle,
                  fillColor: const Color(0xff25292e),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    // borderSide: BorderSide(width: 1.w,color: Colors.white)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35),
                    // borderSide: BorderSide(color: Colors.white,width: 1.w),
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white, size: 27)),
            ),
            const SizedBox(
              height: 14,
            ),
            Expanded(
              child: BlocBuilder<LocaldataBloc, LocaldataState>(
                builder: (context, state) {
                  switch (state.status) {
                    case LocalStatus.initial:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case LocalStatus.failed:
                      return Center(
                          child: Text(
                        "Failed",
                        style: TextTh.profilestyle,
                      ));
                    case LocalStatus.succes:
                      return state.user.isEmpty
                          ? Center(
                              child: Text(
                              "No Users",
                              style: TextTh.profilestyle,
                            ))
                          : ListView.builder(
                              itemCount: state.user.length,
                              // reverse: true,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Slidable(
                                    key: Key(state.user[index].id.toString()),
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (_) {
                                            BlocProvider.of<LocaldataBloc>(
                                                    context)
                                                .add(
                                              LocaldataDeleteEvent(
                                                  id: state.user[index].id!),
                                            );
                                          },
                                          backgroundColor:
                                              const Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        )
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // from = state.user[index].email;
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              child: ChatScreen(
                                                name: state.user[index].name,
                                                email: state.user[index].email,
                                              ),
                                              curve: Curves.easeIn,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                            ),
                                          );
                                        },
                                        child: BlocBuilder<ChatBloc, ChatState>(
                                            builder: (context, st) {
                                          // print('Work ${st.online}');
                                          return Container(
                                            decoration: const BoxDecoration(
                                                color: Color(0xff25292e),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    'https://static1.colliderimages.com/wordpress/wp-content/uploads/2022/11/Feature%20Image-1.jpg'),
                                              ),
                                              title: Text(
                                                state.user[index]
                                                    .name, // "Title",
                                                style: TextTh.chatstyle,
                                              ),
                                              subtitle: Text(
                                                state.user[index]
                                                    .email, //  "Subtitle",
                                                style: TextTh.logsubstyle,
                                              ),
                                              trailing:
                                                  // const Icon(
                                                  //   Icons
                                                  //       .arrow_forward_ios_outlined,
                                                  //   color: Colors.white,
                                                  //   size: 15,
                                                  // )
                                                  Container(
                                                height: 6,
                                                width: 6,
                                                decoration: BoxDecoration(
                                                    color: st.index == index
                                                        ? Colors.green
                                                        : Colors.grey[700],
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff25292e),
        onPressed: () {
          saveBox(context);
        },
        child: const Icon(
          Icons.add_comment,
          color: Colors.white,
        ),
      ).animate(delay: .5000.seconds).fade(duration: 1500.ms).slideY(),
    );
  }
}

Future saveBox(BuildContext context) {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 240,
          // width: 500,
          color: const Color.fromARGB(255, 35, 41, 48),
          child: Column(
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white60,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  hintText: 'Enter Email Address',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _name,
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white60,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(
                    Icons.near_me,
                    color: Colors.white,
                  ),
                  hintText: 'Enter Name',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xff0c1014)),
                ),
                onPressed: () {
                  BlocProvider.of<LocaldataBloc>(context).add(
                      LocaldataEventAdd(email: _email.text, name: _name.text));
                  _email.clear();
                  _name.clear();
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_box_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add your contacts',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
