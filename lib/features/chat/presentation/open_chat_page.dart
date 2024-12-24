import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/widgets/custom_bottom_navbar.dart';
import 'package:hobby/core/widgets/message_tile_widget.dart';
import 'package:hobby/features/chat/presentation/bloc/chat/message_bloc.dart';
import 'package:lottie/lottie.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User? currentUser;
  Map<String, dynamic>? userData;
  Future<void> fetchUserData(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data();
        });
      } else {
        print("no data");
      }
    } catch (e) {
      print("error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        setState(() {
          currentUser = user;
        });
        await fetchUserData(user.uid);
      } else {
        setState(() {
          currentUser = null;
          userData = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    String username = userData?['username'] ?? 'no data';
    return Scaffold(
      backgroundColor: AppColors.notBlack,
      body: BlocProvider(
        create: (context) => MessageBloc()..add(LoadMessagesEvent()),
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            if (state is LoadingMessageState) {
              return Center(
                  child:
                      Lottie.asset('assets/animations/loading_hamster.json'));
            } else if (state is FailureMessageState) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is SuccessMessageState) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final message = state.items[index];
                        if (state.items[index].username == username) {
                          return MessageTileWidget(
                            username: message.username,
                            message: message.messages,
                            isMe: true,
                          );
                        } else {
                          return MessageTileWidget(
                            isMe: false,
                            username: message.username,
                            message: message.messages,
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _controller,
                          decoration: InputDecoration(
                            suffixIconColor: Colors.green,
                            labelText: 'write something',
                            labelStyle: TextStyle(
                                color: const Color.fromARGB(255, 162, 162, 162),
                                fontSize: 16.0),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                String message = _controller.text;

                                if (message.isNotEmpty) {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('messages')
                                        .add({
                                      'messages': message,
                                      'username': username
                                    });
                                    _controller.clear();

                                    context
                                        .read<MessageBloc>()
                                        .add(LoadMessagesEvent());
                                  } catch (e) {
                                    print('Error: $e');
                                  }
                                }
                              },
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 0.0),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(page: 2),
    );
  }
}
