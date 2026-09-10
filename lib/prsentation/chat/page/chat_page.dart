import 'package:flutter/material.dart';
import 'package:job_seeker/prsentation/chat/provider/chat_provider.dart';
import 'package:job_seeker/prsentation/chat/widget/chat_list_widget.dart';
import 'package:job_seeker/prsentation/chat/widget/top_chat_bar_widget.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final bool asRecruiter;
  const ChatPage({super.key, this.asRecruiter = false});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<ChatProvider>().fetchRecuiterProfile(
            asRecruiter: widget.asRecruiter,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TopChatBarWidget(asRecruiter: widget.asRecruiter),
          const SizedBox(height: 12),
          Expanded(
            child: chatProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : chatProvider.recuitersList.isEmpty
                    ? Center(
                        child: Text(
                          widget.asRecruiter
                              ? 'No job applicant chats yet.'
                              : 'No recruiter chats yet. Apply to a job to start chatting.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: chatProvider.recuitersList.length,
                        itemBuilder: (context, index) {
                          return ChatListWidget(
                            roomEntity: chatProvider.recuitersList[index],
                            asRecruiter: widget.asRecruiter,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
