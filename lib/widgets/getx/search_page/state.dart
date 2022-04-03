import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SearchPageState {
  final TextEditingController textEditingController = TextEditingController();
  final showCancel=false.obs;
  var cancelPad=70.0;
  var searchText="".obs;
  var searchModeOrViewMode=1.obs;
  SearchPageState() {
    ///Initialize variables
  }
}
