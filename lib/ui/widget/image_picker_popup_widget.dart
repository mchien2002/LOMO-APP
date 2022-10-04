
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lomo/res/dimens.dart';
// import 'package:lomo/res/strings.dart';
// import 'package:lomo/res/theme/text_theme.dart';
// import 'package:lomo/res/theme/theme_manager.dart';
//
// class ImagePickerPopupWidget extends StatelessWidget {
//   final ImagePicker picker;
//   final Function(File) onPickedFile;
//   final double maxWidth;
//   final double maxHeight;
//   ImagePickerPopupWidget(
//       {@required this.picker,
//       @required this.onPickedFile,
//       this.maxWidth,
//       this.maxHeight});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: getColor().white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             _buildItem(context, ImageSource.camera,
//                 Strings.openCamera.localize(context)),
//             Divider(
//               height: 1,
//             ),
//             _buildItem(context, ImageSource.gallery,
//                 Strings.openGallery.localize(context)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildItem(
//       BuildContext context, ImageSource imageSource, String title) {
//     return InkWell(
//       onTap: () async {
//         try {
//           final PickedFile pickedFile = await picker.getImage(
//               source: imageSource,
//               maxWidth: maxWidth,
//               maxHeight: maxHeight,
//               imageQuality: 90);
//           onPickedFile(File(pickedFile.path));
//           Navigator.pop(context);
//         } catch (e) {
//           print(e);
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: Dimens.padding),
//         child: Text(
//           title,
//           style: textTheme(context).body.colorDart,
//         ),
//       ),
//     );
//   }
// }
