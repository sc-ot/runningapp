import 'package:bestpractice/controller.dart';
import 'package:bestpractice/core/db/storage.dart';
import 'package:bestpractice/core/model/run.dart';
import 'package:bestpractice/core/utils/constants.dart';

class HistoryController extends Controller{
late List<Run> runs;

@override
  void onInit() {
    Storage.load(Constants.HISTORY_RUN).then((storageList) {
      runs = [];
      
      if(storageList != null){
        runs = storageList.cast<Run>();
      }
      
      setState(SUCCESS());
    });
    super.onInit();
  }
}