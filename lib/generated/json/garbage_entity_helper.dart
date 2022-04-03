import 'package:flutter_rubbish/entity/garbage_entity.dart';

garbageEntityFromJson(GarbageEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => GarbageData().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> garbageEntityToJson(GarbageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['data'] =  entity.data?.map((v) => v.toJson())?.toList();
	return data;
}

garbageDataFromJson(GarbageData data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['alias'] != null) {
		data.alias = json['alias'].toString();
	}
	if (json['description'] != null) {
		data.description = json['description'].toString();
	}
	if (json['description'] != null) {
		data.description1 = json['description1'].toString();
	}
	if (json['description'] != null) {
		data.description2 = json['description2'].toString();
	}
	if (json['description'] != null) {
		data.description3 = json['description3'].toString();
	}
	if (json['tips'] != null) {
		data.tips = json['tips'].toString();
	}
	if (json['items'] != null) {
		data.items = (json['items'] as List).map((v) => GarbageDataItems().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> garbageDataToJson(GarbageData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['alias'] = entity.alias;
	data['description'] = entity.description;
	data['description1'] = entity.description1;
	data['description2'] = entity.description2;
	data['description3'] = entity.description3;
	data['tips'] = entity.tips;
	data['items'] =  entity.items?.map((v) => v.toJson())?.toList();
	return data;
}

garbageDataItemsFromJson(GarbageDataItems data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['category'] != null) {
		data.category = json['category'].toString();
	}
	if (json['alias'] != null) {
		data.alias = json['alias'].toString();
	}
	if (json['shortcut'] != null) {
		data.shortcut = json['shortcut'].toString();
	}
	return data;
}

Map<String, dynamic> garbageDataItemsToJson(GarbageDataItems entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['category'] = entity.category;
	data['alias'] = entity.alias;
	data['shortcut'] = entity.shortcut;
	return data;
}