enum Status { online, offline }

enum SubmissionType { single, multiple }

enum ActionType { create, update }

// name of folder save image in server ( use for server )
enum UploadDirName { post, avatar, background, dating, report }

extension UploadDirNameExt on UploadDirName {
  String get name {
    switch (this) {
      case UploadDirName.post:
        return "post";
      case UploadDirName.avatar:
        return "avatar";
      case UploadDirName.background:
        return "background";
      case UploadDirName.dating:
        return "dating";
      case UploadDirName.report:
        return "report";
      default:
        return "";
    }
  }
}
