import 'package:flutter/material.dart';

enum LinkFilter { all, unread, read, favorites }

class LinkItem {
  final int id;
  final String title;
  final String domain;
  final String collectionId;
  final String date;
  bool read;
  bool favorite;
  final Color thumbBg;
  final String thumbEmoji;
  final String description;

  LinkItem({
    required this.id,
    required this.title,
    required this.domain,
    required this.collectionId,
    required this.date,
    this.read = false,
    this.favorite = false,
    required this.thumbBg,
    required this.thumbEmoji,
    required this.description,
  });
}

class Collection {
  final String id;
  final String name;
  final String emoji;

  const Collection({required this.id, required this.name, required this.emoji});
}
