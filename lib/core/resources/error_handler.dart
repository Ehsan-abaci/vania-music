// ignore_for_file: deprecated_member_use



enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTHORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECEIVE_TIMEOUT,
  SEND_TIMEOUT,
  CASH_ERROR,
  NO_INTERNET_CONNECTION,
  DEEFAULT,
}


class ResponseCode {
  // Api status code
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 201;
  static const int BAD_REQUEST = 400;
  static const int FORBIDDEN = 403;
  static const int UNAUTHORISED = 401;
  static const int NOT_FOUND = 404;
  static const int INTERNAL_SERVER_ERROR = 500;

  // local status code
  static const int UNKNOWN = -1;
  static const int CONNECT_TIMEOUT = -2;
  static const int CANCEL = -3;
  static const int RECEIVE_TIMEOUT = -4;
  static const int SEND_TIMEOUT = -5;
  static const int CASH_ERROR = -6;
  static const int NO_INTERNET_CONNECTION = -7;
}

class ResponseMessage {
  // Api status code
  static const String SUCCESS = "success";
  static const String NO_CONTENT = "no_content";
  static const String BAD_REQUEST = "bad_request_error";
  static const String FORBIDDEN = "forbidden_error";
  static const String UNAUTHORISED = "unauthorized_error";
  static const String NOT_FOUND = "not_found_error";
  static const String INTERNAL_SERVER_ERROR = "internal_server_error";

  // local status code
  static const String UNKNOWN = "Unknow error";
  static const String CONNECT_TIMEOUT = "timeout_error";
  static const String CANCEL = "cancel_error";
  static const String RECEIVE_TIMEOUT = "timeout_error";
  static const String SEND_TIMEOUT = "timeout_error";
  static const String CASH_ERROR = "cache_error";
  static const String NO_INTERNET_CONNECTION = "No network connection";
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
