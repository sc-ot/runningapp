import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'run.g.dart';


@JsonSerializable()
@HiveType(typeId: 2)
class Run {

   @HiveField(1)
  late double runDistance;
   @HiveField(2)
  late DateTime date;
   @HiveField(3)
  late double caloriesBurned;
   @HiveField(4)
  late double avgSpeed;
   @HiveField(5)
  late int runHour;
   @HiveField(6)
  late int runMinutes;
   @HiveField(7)
  late int runSeconds;

  Run(this.runDistance, this.date, this.caloriesBurned, this.avgSpeed, this.runHour, this.runMinutes, this.runSeconds);
  factory Run.fromJson(Map<String, dynamic> json) => _$RunFromJson(json);
  Map<String, dynamic> toJson() => _$RunToJson(this);

}