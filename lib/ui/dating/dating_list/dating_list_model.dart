import 'package:lomo/app/lomo_app.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/models/city.dart';
import 'package:lomo/data/api/models/constant_list.dart';
import 'package:lomo/data/api/models/dating_image.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/api/models/zodiac.dart';
import 'package:lomo/data/eventbus/change_dating_view_type_event.dart';
import 'package:lomo/data/eventbus/reload_dating_list_event.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/ui/base/base_list_model.dart';
import 'package:lomo/ui/base/base_model.dart';
import 'package:lomo/util/common_utils.dart';

import '../../../data/api/models/filter_request_item.dart';

class DatingListModel extends BaseListModel<User> {
  final _userRepository = locator<UserRepository>();
  List<FilterRequestItem>? filters;
  bool isShowGrid = false;

  ViewState get initState => locator<UserModel>().user!.hasDatingProfile
      ? ViewState.loading
      : ViewState.loaded;

  init() {
    eventBus.on<ReloadDatingListEvent>().listen((event) async {
      refresh();
    });
    eventBus.on<ChangeDatingViewTypeEvent>().listen((event) async {
      isShowGrid = !isShowGrid;
      notifyListeners();
    });
  }

  @override
  Future<List<User>> getData({params,bool isClear = false}) async {
    final datings = await _userRepository.getDatingList(
        page: page, limit: pageSize, filters: filters);
    return shuffle(datings);
  }

  List<User> testUser() {
    return List.generate(
      100,
      (index) => User(
        id: "6087d159791f9b0510417769",
        name: "Anh Râu Kẽm $index",
        avatar: "/srv-cdn/image/d33ace09-8ff3-4977-a40d-086f591bc80f.jpeg",
        birthday: DateTime(1992, 1, 1),
        isFollow: false,
        quote:
            "Em trông khác xa những đứa bình thường mà anh vẫn thấy ở trong trường. Got ‘em careless vibe, Spotify luôn bật ở trên..",
        sogiescs: [
          Sogiesc(name: "LGBT+"),
          Sogiesc(name: "Phi nhĩ nguyên giới"),
          Sogiesc(name: "chuyễn giới nam"),
          if (index % 2 == 1) Sogiesc(name: "chuyễn giới nữ")
        ],
        zodiac: Zodiac(name: "Song ngư"),
        careers: [KeyValue(name: "Marketing"), KeyValue(name: "Dạy học")],
        literacy: Literacy(name: "HCA"),
        hobbies: [Hobby(name: "Đạp xe"), Hobby(name: "Bơi lội")],
        province: City(id: "1", name: "tphcm"),
        datingImages: [
          DatingImage(
              link: "/srv-cdn/image/d33ace09-8ff3-4977-a40d-086f591bc80f.jpeg",
              isVerify: true),
          DatingImage(
              link: "/srv-cdn/image/d33ace09-8ff3-4977-a40d-086f591bc80f.jpeg",
              isVerify: false),
          DatingImage(
              link: "/srv-cdn/image/d33ace09-8ff3-4977-a40d-086f591bc80f.jpeg"),
          DatingImage(
              link: "/srv-cdn/image/d33ace09-8ff3-4977-a40d-086f591bc80f.jpeg")
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
