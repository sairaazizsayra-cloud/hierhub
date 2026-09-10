import 'package:flutter/material.dart';
import 'package:job_seeker/domain/entity/room_entity.dart';
import 'package:job_seeker/prsentation/chat/page/user_chat_screen_page.dart';

class ChatListWidget extends StatelessWidget {
  final RoomEntity roomEntity;
  final bool asRecruiter;

  const ChatListWidget({
    super.key,
    required this.roomEntity,
    this.asRecruiter = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = asRecruiter
        ? (roomEntity.seekerName.isEmpty ? 'Job applicant' : roomEntity.seekerName)
        : (roomEntity.recuiterProfile.organisation.isEmpty
            ? roomEntity.recuiterProfile.name
            : roomEntity.recuiterProfile.organisation);
    final subtitle = asRecruiter
        ? (roomEntity.jobTitle.isEmpty
            ? 'Job chat'
            : '${roomEntity.jobTitle} job')
        : roomEntity.recuiterProfile.name;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreenPage(
              roomEntity: roomEntity,
              asRecruiter: asRecruiter,
            ),
          ),
        );
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(asRecruiter ? Icons.person : Icons.business),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
