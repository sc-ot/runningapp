import 'package:hive/hive.dart';

part 'cache_data.g.dart';

@HiveType(typeId: 1)
class CacheData {
  @HiveField(1)
  late String path;
  @HiveField(2)
  late dynamic body;
  @HiveField(3)
  late dynamic headers;
  @HiveField(4)
  late dynamic queryParams;
  @HiveField(5)
  late DateTime timestamp;
  @HiveField(6)
  late String? response;
}
