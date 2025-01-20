import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'checkin.g.dart';

@HiveType(typeId: 0)
class Checkin {
  @HiveField(0)
  final TimeOfDay time;

  @HiveField(1)
  final String note;

  Checkin({required this.time, required this.note});
}
