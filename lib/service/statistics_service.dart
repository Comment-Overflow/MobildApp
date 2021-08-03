import 'package:comment_overflow/model/response_dto/statistics_dto.dart';
import 'package:comment_overflow/utils/http_util.dart';
import 'package:comment_overflow/utils/socket_client.dart';
import 'package:dio/dio.dart';

class StatisticsService {
  /// Call on entering statistics page. [onUpdateStatistics] is a
  /// callback that accepts StatisticsDTO when new data arrives.
  static Future<Response> initStatistics(
      void Function(StatisticsDTO) onUpdateStatistics) async {
    SocketClient().enterStatisticsChannel(onUpdateStatistics);
    return HttpUtil().dio.get('/forum/statistics');
  }

  /// Call on leaving statistics page.
  static void dispose() {
    SocketClient().leaveStatisticsChannel();
  }
}
