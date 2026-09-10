import 'package:flutter/material.dart';
import 'package:job_seeker/domain/entity/room_entity.dart';

class ChatProvider extends ChangeNotifier {
  final dynamic datasource;

  List<RoomEntity> recuitersList = [];
  String? error;
  bool isLoading = false;

  ChatProvider({required this.datasource});

  Future<void> fetchRecuiterProfile({bool asRecruiter = false}) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await datasource.fetchUsersConnection(
        asRecruiter: asRecruiter,
      );
      recuitersList = data;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
