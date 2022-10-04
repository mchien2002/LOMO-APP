import 'dart:io';
import 'dart:math';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart';
import 'package:lomo/app/app_model.dart';
import 'package:lomo/app/user_model.dart';
import 'package:lomo/data/api/api_constants.dart';
import 'package:lomo/data/api/models/error_log.dart';
import 'package:lomo/data/api/models/sogiesc.dart';
import 'package:lomo/data/api/models/user.dart';
import 'package:lomo/data/repositories/user_repository.dart';
import 'package:lomo/di/locator.dart';
import 'package:lomo/res/colors.dart';
import 'package:lomo/res/constant.dart';
import 'package:lomo/res/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'navigator_service.dart';

Future<void> launchAction(
  String url, {
  bool forceWebView = false,
  bool enableJavaScript = false,
}) async {
  if (await canLaunch(url))
    await launch(url,
        forceWebView: forceWebView, enableJavaScript: enableJavaScript);
  else
    throw 'Could not launch $url';
}

showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
  final context =
      locator<NavigationService>().navigatorKey.currentState?.context;
  Fluttertoast.showToast(
      msg: context != null ? message.localize(context) : message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      backgroundColor: DColors.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

downloadImage(String? imageUrl) async {
  try {
    // Saved with this method.
    var imageId =
        await ImageDownloader.downloadImage(getFullLinkImage(imageUrl));
    if (imageId == null) {
      return;
    } else {
      showToast(Strings.saveImageSuccess.localize(
          locator<NavigationService>().navigatorKey.currentState!.context));
    }
  } on Exception catch (error) {
    print(error);
  }
}

String formatNumber(dynamic value) {
  final formatter = NumberFormat("#,###.#");
  return formatter.format(value);
}

String formatCurrency(dynamic value) {
  final formatter = NumberFormat.currency(locale: "vi_VN", symbol: "VND");
  return formatter.format(value);
}

String formatNumberDivThousand(int? value) {
  final formatter = NumberFormat("#,###.#");
  if (value == null) return "";
  if (value < 1000000) {
    return formatter.format(value);
  } else {
    double number = value / 1000;
    return formatter.format(number) + "K";
  }
}

String formatNumberDistance(dynamic value) {
  final formatter = NumberFormat("#,###.#");
  final formatMeter = NumberFormat("#,###.##");
  if (value == null) return "";
  if (value < 10) {
    return "0.01 km";
  } else if (value >= 10 && value < 1000) {
    double number = value / 1000;
    return formatMeter.format(number) + " km";
  } else {
    double number = value / 1000;
    return formatter.format(number) + " km";
  }
}

String getFeeling(String? value) {
  if (value == null) return "";
  for (var i in Constants.feeling) {
    if (i.name == value) return i.iconData!;
  }
  return "";
}

File createFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }

  return file;
}

void insertItemIndex(Sogiesc value, List<Sogiesc> listItems) {
  if (listItems.isEmpty == true) {
    listItems.add(value);
    return;
  }
  for (int i = 0; i < listItems.length; i++) {
    if (value.priority < listItems[i].priority) {
      listItems.insert(i, value);
      return;
    }
  }
  listItems.add(value);
}

List<T> shuffle<T>(List<T> original, {int length = -1}) {
  List items = <T>[]..addAll(original);
  int bottom = 0;
  if (length != -1 && length <= items.length) {
    bottom = items.length - length;
  }
  var random = new Random();
  // Go through all elements.
  for (var i = items.length - 1; i > bottom; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  final end = length == -1 || length >= items.length ? items.length : length;

  return items.sublist(0, end) as List<T>;
}

bool isUpdate(String oldVersion, String newVersion) {
  bool result = false;
  try {
    List<String> oldVersions = oldVersion.split(".");
    List<String> newVersions = newVersion.split(".");
    for (int i = 0; i < oldVersions.length; i++) {
      if (int.parse(newVersions[i]) > int.parse(oldVersions[i])) {
        result = true;
      }
    }
  } catch (e) {
    print(e);
  }
  return result;
}

Pattern tagUserPattern =
    r'@([a-zA-Z0-9]|à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ|À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ|è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ|È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ|ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ|Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ|ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ|Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ|ì|í|ị|ỉ|ĩ|Ì|Í|Ị|Ỉ|Ĩ|đ|Đ|ỳ|ý|ỵ|ỷ|ỹ|Ỳ|Ý|Ỵ|Ỷ|Ỹ|\s)+';

String replaceUserNameWithUserId(String text, List<User> usersTagged) {
  String result = text.substring(0);

  try {
    usersTagged.forEach((element) {
      if (result.contains("@${element.name}")) {
        result = result.replaceFirst("@${element.name}", "@${element.id}");
      }
    });
  } catch (e) {
    print(e);
  }

  return result;
}

List<String> getListUserIdFromTaggedText(String text, List<User> usersTagged) {
  String tag = text.substring(0);
  List<String> result = [];
  RegExp exp = new RegExp(tagUserPattern.toString());

  try {
    if (tag.isNotEmpty == true) {
      Iterable<RegExpMatch> matches = exp.allMatches(tag);
      matches.forEach((match) {
        User user = usersTagged.firstWhere((element) {
          String matchTagText = tag.substring(match.start + 1, match.end);
          return element.lomoId == matchTagText;
        }, orElse: () => null as User);
        result.add(user.id!);
      });
    }
  } catch (e) {
    print(e);
  }

  return result;
}

List<User> getListUserFromTaggedText(String text, List<User> usersTagged) {
  String tagText = text.substring(0);
  List<User> result = [];
  try {
    usersTagged.forEach((element) {
      if (tagText.contains("@${element.name}")) {
        result.add(element);
        tagText = tagText.replaceFirst("@${element.name}", "");
      }
    });
  } catch (e) {
    print(e);
  }

  return result;
}

List<String> getHashTagsFromText(String? text) {
  List<String> result = [];

  if (text?.isNotEmpty == true && text!.contains("#")) {
    Pattern pattern =
        r'#[_\d\wàáạảãâầấậẩẫăằắặẳẵÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴèéẹẻẽêềếệểễÈÉẸẺẼÊỀẾỆỂỄòóọỏõôồốộổỗơờớợởỡÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠùúụủũưừứựửữÙÚỤỦŨƯỪỨỰỬỮìíịỉĩÌÍỊỈĨđĐỳýỵỷỹỲÝỴỶỸ]{2,}';
    RegExp exp = new RegExp(pattern.toString());
    Iterable<RegExpMatch> matches = exp.allMatches(text);
    matches.forEach((match) {
      String hashtag =
          text.substring(match.start + 1, match.end).replaceAll(" ", "");
      if (!result.contains(hashtag)) {
        result.add(hashtag);
      }
    });
  }

  return result;
}

String removeInvalidSpaceAndEnter(String? text) {
  if (text?.isNotEmpty == true) {
    final replaceInvalidSpace = text!.replaceAll(RegExp(r'\s{10}'), " ");
    return replaceInvalidSpace.replaceAll(RegExp(r'\n\n+'), "\n\n");
  } else {
    return "";
  }
}

String replaceEnterCharacterInTextForHtml(String? text) {
  if (text?.isNotEmpty == true) {
    return text!.replaceAll("\n", "<br>");
  } else {
    return "";
  }
}

String replaceUserIdByUserName(String? text, List<User>? users) {
  String result = "";
  if (text != null) {
    result = text.substring(0);
    users?.forEach((element) {
      result = result.replaceAll(element.id!, element.name!);
    });
  }

  return result;
}

String convertVietnamToEnglish(String text) {
  final _vietnamese = 'aAeEoOuUiIdDyY';
  final _vietnameseRegex = <RegExp>[
    RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
    RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
    RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
    RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
    RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
    RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
    RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
    RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
    RegExp(r'ì|í|ị|ỉ|ĩ'),
    RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
    RegExp(r'đ'),
    RegExp(r'Đ'),
    RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
    RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ')
  ];
  var result = text;
  for (var i = 0; i < _vietnamese.length; ++i) {
    result = result.replaceAll(_vietnameseRegex[i], _vietnamese[i]);
  }
  return result;
}

String urlEncode({required String text}) {
  String output = text;

  var detectHash = text.contains('#');
  var detectAnd = text.contains('&');
  var detectSlash = text.contains('/');
  var detectSpace = text.contains(' ');

  // if (detectHash == true) {
  //   output = output.replaceAll('#', '%23');
  // }
  //
  // if (detectAnd == true) {
  //   output = output.replaceAll('#', '%26');
  // }
  //
  // if (detectSlash == true) {
  //   output = output.replaceAll('#', '%2F');
  // }

  if (detectSpace == true) {
    output = output.replaceAll(' ', '%20');
  }

  return output;
}

shareLink(String link) {
  Share.share(link);
}

Future<String> getLogError(String errorMessage) async {
  String phone;
  final appModel = locator<AppModel>();
  final user = locator<UserModel>().user;
  if (user?.phone?.isNotEmpty == true) {
    phone = user!.phone!;
  } else {
    phone = (await locator<UserRepository>().getPhone()) ?? "";
  }
  String os = Platform.isAndroid ? "android" : "ios";
  return phone +
      " - " +
      os +
      " - " +
      appModel.deviceId +
      " - " +
      Platform.operatingSystemVersion +
      " - " +
      errorMessage;
}

String getFullLinkImage(String? url) {
  if (url?.isNotEmpty == true) {
    return url!.contains("http") ? url : PHOTO_URL + url;
  } else {
    return "";
  }
}

String getFullLinkVideo(String? url) {
  if (url?.isNotEmpty == true) {
    return url!.contains("http") ? url : VIDEO_URL + url;
  } else {
    return "";
  }
}

Future<String> getDownloadPath(String fileName) async {
  final downloadDir = await findDownloadDir();
  final savedDir = Directory(downloadDir);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
  return downloadDir + "/" + fileName;
}

Future<String> findDownloadDir() async {
  var externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}

bool canOpenChatWith(String? userId) {
  return !locator<AppModel>().listDisableChat.contains(userId);
}

navigateToStore() {
  launch(Platform.isAndroid ? GOOGLE_STORE_LINK : APPLE_STORE_LINK);
}

ErrorLog getErrorLog(
    {required Object exception,
    required StackTrace stackTrace,
    String? className}) {
  final appModel = locator<AppModel>();
  String logError;
  var logs = stackTrace.toString().split("\n");
  if (logs.length > 10) {
    logError = logs.sublist(0, 10).join("\n");
  } else {
    logError = logs.join("\n");
  }
  return ErrorLog(
      user: locator<UserModel>().user?.id,
      message: exception.toString() + "\n" + logError,
      className: className ?? "",
      device: appModel.deviceName,
      osVersion: appModel.osVersion);
}

Future<T> elapsedFuture<T>(
  Future<T> future, {
  String? prefix,
}) async {
  final Stopwatch stopwatch = Stopwatch()..start();
  final T result = await future;
  stopwatch.stop();
  print('${prefix != null ? '$prefix: ' : ''}${stopwatch.elapsed}');
  return result;
}
