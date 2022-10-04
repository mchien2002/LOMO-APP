const DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ssZ";
const DATE_FORMAT = "dd/MM/yyyy";
final minDate = DateTime(1900, 1, 1, 0, 0, 0);
final maxDate = DateTime(3000, 1, 1, 0, 0, 0);
const MIN_YEAR_OLD_USED_APP = 18;
const PAGE_SIZE = 30;

const BASE_URL_DEV = "http://128.199.69.106:3001"; // ip server dev
const UPLOAD_PHOTO_URL_DEV = "http://128.199.69.106:3001";
const DOWNLOAD_PHOTO_URL_DEV = "http://128.199.69.106:9000";

// const BASE_URL_DEV = "http://192.168.16.110:3001"; // ip máy anh Nghĩa
// const UPLOAD_PHOTO_URL_DEV = "http://128.199.69.106:3001";
// const DOWNLOAD_PHOTO_URL_DEV = "http://128.199.69.106:9000";

const BASE_URL_PROD = "https://pro.lomosocial.com"; // production
const UPLOAD_PHOTO_URL_PROD = "https://pro.lomosocial.com"; //production
const DOWNLOAD_PHOTO_URL_PROD = "https://ss1.lomosocial.com"; // production

const BASE_URL_STA = "https://sta.lomosocial.com"; // staging
const UPLOAD_PHOTO_URL_STA = "https://sta.lomosocial.com"; //staging
const DOWNLOAD_PHOTO_URL_STA = "https://ss1.lomosocial.com"; // staging

const WEB_DOMAIN = "https://lomosocial.com";

String PHOTO_URL = "";
String VIDEO_URL = "";
String? UPLOAD_PHOTO_URL;

const VQMM_DEV = "https://vongquay-dev.lomosocial.com/trang-chu";
const VQMM_PROD = "https://vongquay.lomosocial.com/trang-chu";
const VQMM_SHARE_LINK = "";

const FACEBOOK_URL = "https://graph.facebook.com";
const FACEBOOK_PROFILE =
    "/v2.12/me?fields=name,first_name,last_name,email&access_token=%s";
const GOOGLE_STORE_LINK =
    "https://play.google.com/store/apps/details?id=vn.netacom.lomo";
const APPLE_STORE_LINK =
    "https://apps.apple.com/us/app/lomo-mxh-h%E1%BA%B9n-h%C3%B2-lgbt/id1542295325";
const FACEBOOK_FAN_PAGE_LINK = "https://www.facebook.com/NetaLomo";
const FACEBOOK_PROTOCOL_IOS_LINK = "fb://page?id=106260551321335";
const FACEBOOK_PROTOCOL_ANDROID_LINK = "fb://page/106260551321335";
const REDIRECT_TO_STORE_LINK = "https://lomo.onelink.me/82Zz/fgdgen1sg";

const REFRESH_TOKEN = "/v1/app/refresh-token/%s";
const LIST_TOTAL_CONSTANT = "/v1/app/constant";
const UPLOAD_IMAGE = "/v1/app/image?dir=%s";
const UPLOAD_VIDEO = "/v1/app/video?dir=%s";
const UPLOAD_IMAGES = "/v1/app/images?dir=%s";
const UPLOAD_PHOTO = "/upload/photo";
const PROVINCE = "/v1/app/province";
const DISTRICT = "/v1/app/district";
const WARD = "/v1/app/ward";
// user
const REPORT = "/v1/app/report";
const LOGIN_BY_PHONE = "/v1/app/register";
const CONFIRM_OTP = "/v1/app/register/otp";
const RE_SEND_OTP = "/login/resend_otp";
const MY_PROFILE = "/v1/app/me"; // get
const USER_PROFILE = "/v1/app/me"; // put
const DELETE_ACCOUNT = "/v1/app/me"; // put
const DETAIL_USER = "/v1/app/user/%s"; // get  profile top 1
const LOGOUT = "/v1/app/me/%s?token=%s"; // delete
const SUGGEST_USER = "/v1/app/user/idol/paging";
const DELETE_TOKEN_WHEN_LOGOUT = "/v1/app/device/%s";
const USER_UPDATE_PROFILE = "/v1/app/me";
const FOLLOW_USER =
    "/v1/app/interactive/following/%s"; // follow with method post and unfollow with method delete
const BLOCK_USER = "/v1/app/interactive/block/%s";
// const LIST_USER_BLOCKED = "/v1/app/interactive/block/paging";
const LIST_USER_BLOCKED = "/v1/app/interactive/block/%s";
const SEND_BEAR = "/v1/app/interactive/bear/%s";
const SEARCH_USER = "/v1/app/user/search";
const SEARCH_HASH_TAG = "/v1/app/hashtag";
const SEARCH_USER_TAG = "/v1/app/user/tag";
const FAVORITE_USER =
    "/v1/app/interactive/favorite/%s"; //favorite with method post and unfavorite with method delete
const CHECK_FRIEND = "/v1/app/user/check-friend/%s-%s"; // me - target
const SENT_SAY_HI = "/v1/app/interactive/sayhi/%s"; //target
// List_THEME
const LIST_TOPIC = "/v1/app/topic"; //
const LIST_TOPIC_WITH_TYPE = "/v1/app/topic/discovery";
// new feed
const FAVORITE_POST_LIST = "/v1/app/post/%s/favorite";
const FAVORITE_POST =
    "/v1/app/post/%s/favorite"; // favorite with method post and unfavorite with method delete
const LIST_KNOWLEDGE = "/v1/app/topic/knowledge";
const USER_POST = "/v1/app/post/user/%s"; // nhat ky  ho so
const USER_POST_V3 = "/v1/app/post/user/%s";
const SUGGEST_POST = "/v1/app/post/timeline/%s/%s"; // lng / lat
const FILTER_POST = "/v1/app/post/search";
const FOLLOWING_POST = "/v1/app/post/following/paging";
const CREATE_POST = "/v1/app/post";
const DETAIL_POST = "/v1/app/post/%s";
const DELETE_POST = "/v1/app/post/%s";
const UPDATE_POST = "/v1/app/post/%s";
const FOLLOWERS_USER = "/v1/app/interactive/follower/%s";
const FOLLOWINGS_USER = "/v1/app/interactive/following/%s";
const FAVORITOR_USER = "/v1/app/interactive/favoritor/%s";
//comments
const CREATE_COMMENTS_POST = "/v1/app/post/%s/comment";
const COMMENTS_UNKNOWN_POST = "/v1/app/post/%s/comment/parent/unknown";
const COMMENTS_CHILD_POST = "/v1/app/post/%s/comment/parent/%s";
const COMMENTS_FAVORITE_POST_DELETE = "/v1/app/comment/%s/favorite";
const COMMENTS_DELETE_POST = "/v1/app/post/%s/comment/%s";
//discovery
const DISCOVERY_FEELING_POST = "/v1/app/user/feeling/paging";
const DISCOVERY_HOT_MEMBER = "/v1/app/user/hot";
const DISCOVERY_PARENT = "/v1/app/user/hot/pflag";
const DISCOVERY_LOCATION_POST = "/v1/app/user/location/%s/%s/%s/paging";
const DISCOVERY_HOT_NEWFEED = "/v1/app/post/hot";
const DISCOVERY_HOT_NEAR_USER = "/v1/app/user/near";
const DISCOVERY_LIST = "/v1/app/discovery";
const DISCOVERY_DETAIL = "/v1/app/discovery/%s";
//location
const UPDATE_LOCATION_POST = "/v1/app/user/location";
const POST_UPDATE_ZODIAC = "/v1/app/type/zodiac/paging";
const POST_UPDATE_SOGIESC = "/v1/app/type/sogiesc/paging";
const POST_UPDATE_RELATIONSHIP = "/v1/app/type/relationship/paging";
//event
const EVENTS = "/v1/app/banner";
// gift
const GIFTS = "/v1/app/gift";
const GIFT_DETAIL = "/v1/app/gift/%s";
const POST_ORDER_GIFTS = "/v1/app/order";
const POST_LIST_CHECKIN = "/v1/app/checkin";
const POST_CHECKIN = "/v1/app/checkin";
//Notification
const LIST_NOTIFICATION_PAGING = "/v1/app/notification";
const NOTIFICATION_UPDATE = "/v1/app/notification/%s";
const NOTIFICATION_DETAIL = "/v1/app/push/%s";
// firebase
const PUSH_DEVICE_TOKEN = "/v1/app/device/%s";
// dating
const UPDATE_DATING_PROFILE = "/v1/app/user/dating";
const LIST_DATING = "/v1/app/user/dating/%s/%s";
const VERIFY_DATING_IMAGE = "/v1/app/user/dating/request-verify";
// app
const CHECK_UPDATE_APP = "/v1/app/app-info/check";
// who suits me
const GET_WHO_SUITS_ME_QUESTION = "/v1/app/quiz/user/%s";
const CREATE_WHO_SUITS_ME_QUESTION = "/v1/app/quiz";
const WHO_SUITS_ME_HISTORY = "/v1/app/interactive/quizor/%s";
const WHO_SUITS_ME_RESULT = "/v1/app/interactive/quizer/%s";
const SUBMIT_RESULT_ANSWER = "/v1/app/interactive/quiz/%s";
const HISTORY_QUIZ_DETAIL = "/v1/app/quiz/%s/sender/%s";
const READ_QUIZ = "/v1/app/quiz/read/user/%s";

const SEARCH_USER_ADVANCE = "/v1/app/user/search-advance";
const SEARCH_POST_ADVANCE = "/v1/app/post/search-advance";
const SEARCH_TOPIC_ADVANCE = "/v1/app/topic/search-advance";

// tracking
const TRACKING = "/v1/app/tracking";
const SHARE_POST = "/v1/app/post/%s/share";

// log error
// tracking
const LOG_ERROR = "/v1/app/app-log";

//Referral
const REFERRAL = "/v1/app/user/referral";
