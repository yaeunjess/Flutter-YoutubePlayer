import 'package:dio/dio.dart';
import 'package:flutter_cf_tube/const/api.dart';

import '../model/video_model.dart';

class YoutubeRepository{
  static Future<List<VideoModel>> getVideos() async{
    // GET 요청
    final resp = await Dio().get(
      YOUTUBE_API_BASE_URL,
      queryParameters: {
        'channelId': CF_CHANNEL_ID,
        'maxResults': 50,
        'key': API_KEY,
        'part': 'snippet',
        'order': 'date',
      },
    );

    // GET 요청으로 받은 값들 필터링
    final listWithData = resp.data['items'].where(
        (item) => item?['id']?['videoId'] != null && item?['snippet']?['title'] != null && item?['snippet']?['channelTitle'] != null,
    ); // videoId와 title이 null이 아닌 값들만 필터링

    // 필터링 된 값들을 기반으로 ViewModel 생성
    return listWithData.map<VideoModel>(
        (item) => VideoModel(id: item['id']['videoId'], title: item['snippet']['title'], channelName: item['snippet']['channelTitle']),
    ).toList();
  }
}