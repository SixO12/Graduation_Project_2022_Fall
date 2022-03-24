import 'package:flutter_rubbish/generated/json/base/json_convert_content.dart';

class GarbageEntity with JsonConvert<GarbageEntity> {
	List<GarbageData> data;
}

class GarbageData with JsonConvert<GarbageData> {
	String id;
	String name;
	String alias;
	String description;
	String tips;
	List<GarbageDataItems> items;
}

class GarbageDataItems with JsonConvert<GarbageDataItems> {
	String id;
	String name;
	String category;
	String alias;
	String shortcut;
}
