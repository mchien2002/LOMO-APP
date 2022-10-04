import 'package:diacritic/diacritic.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/relationship.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:rxdart/rxdart.dart';

class DropdownApiWidgetModel extends BaseModel {
  DropdownApiWidgetModel(this.getDropdown);

  Future<List<Zodiac>?> Function() getDropdown;

  @override
  ViewState get viewState => ViewState.loaded;

  final listItemsSubject = BehaviorSubject<List<Zodiac>>();

  getListItems() async {
    await callApi(doSomething: () async {
      final response = await getDropdown();
      listItemsSubject.sink.add(response!);
    });
  }

  @override
  void dispose() {
    super.dispose();
    listItemsSubject.close();
  }
}

class DropdownSogiescWidgetModel extends BaseModel {
  DropdownSogiescWidgetModel(this.getDropdown);

  Future<List<Sogiesc>> Function() getDropdown;

  List<Sogiesc> listSelected = [];

  List<Sogiesc>? listSogiescs;

  @override
  ViewState get viewState => ViewState.loaded;

  final listItemsSubject = BehaviorSubject<List<Sogiesc>>();

  getListItems() async {
    await callApi(doSomething: () async {
      var response = await getDropdown();
      listSogiescs?.clear();
      listSogiescs = response;
      print(response.length);
      if (listSogiescs?.isNotEmpty == true)
        listItemsSubject.sink.add(listSogiescs!);
    });
  }

  void initIndexForItem(List<Sogiesc>? listItems) {
    if (listItems?.isNotEmpty == true && listSelected.isNotEmpty == true) {
      listItems?.forEach((e) {
        final idx = listSelected.indexWhere((i) => i.id == e.id);
        if (idx != -1) listSelected[idx].priority = e.priority;
      });
    }
  }

  void selectedAction(List<Sogiesc>? listItems, int index) {
    if (listItems?.isNotEmpty == true) {
      final idx = listSelected.indexWhere((e) => e.id == listItems![index].id);
      if (idx != -1) {
        listSelected.removeAt(idx);
      } else {
        listSelected.add(listItems![index]);
      }
      listSelected.sort((a, b) => a.priority > b.priority ? 1 : 0);
      //--------------------------------------------------------------------------------
      print(listSelected.map((e) => e.name).toList());
      print(listSelected.map((e) => e.priority).toList());
    }
  }

  searchSogiesc(String? keySearch) async {
    if (keySearch == "" || keySearch == null) {
      listItemsSubject.sink.add(listSogiescs ?? []);
    } else {
      if (listSogiescs?.isNotEmpty == true)
        listItemsSubject.sink.add(listSogiescs!
            .where((element) => removeDiacritics(element.name!.toLowerCase())
                .contains(removeDiacritics(keySearch.toLowerCase())))
            .toList());
    }
  }

  @override
  void dispose() {
    super.dispose();
    listItemsSubject.close();
  }
}

class DropdownRelationshipWidgetModel extends BaseModel {
  DropdownRelationshipWidgetModel(this.getDropdown);

  Future<List<Relationship>?> Function() getDropdown;

  @override
  ViewState get viewState => ViewState.loaded;

  final listItemsSubject = BehaviorSubject<List<Relationship>>();

  getListItems() async {
    await callApi(doSomething: () async {
      var response = await getDropdown();
      print(response!.length);
      listItemsSubject.sink.add(response);
    });
  }

  @override
  void dispose() {
    super.dispose();
    listItemsSubject.close();
  }
}

class DropdownAddressWidgetModel extends BaseModel {
  DropdownAddressWidgetModel(this.getDropdown);

  Future<List<City>> Function({required String id}) getDropdown;

  @override
  ViewState get viewState => ViewState.loaded;

  final listItemsSubject = BehaviorSubject<List<City>>();

  getListItems({required String id}) async {
    await callApi(doSomething: () async {
      var response = await getDropdown(id: id);
      print(response.length);
      listItemsSubject.sink.add(response);
    });
  }

  @override
  void dispose() {
    super.dispose();
    listItemsSubject.close();
  }
}
