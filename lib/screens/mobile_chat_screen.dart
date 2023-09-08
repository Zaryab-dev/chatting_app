import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../colors.dart';
import '../models/user_model.dart';
import '../pages/auth/controller/auth_controller.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-chat-screen';
  final String uid, name;
  const MobileChatScreen({Key? key, required this.uid, required this.name}) : super(key: key);

  @override
  ConsumerState<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).updateOnlineStatus(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider).updateOnlineStatus(false);
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context, ) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(widget.uid),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name),
                BounceInRight(
                  child: snapshot.data!.isOnline ? ZoomIn(child: const Text('Online',
                    style: TextStyle(fontSize: 13,fontWeight: FontWeight.normal),))
                      : BounceInDown(child: const Text('Offline',
                    style: TextStyle(fontSize: 13,fontWeight: FontWeight.normal),)),

                ),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              receiverUserId: widget.uid,
            ),
          ),
          BottomChatField(
            uid: widget.uid,
          ),
        ],
      ),
    );
  }
}
