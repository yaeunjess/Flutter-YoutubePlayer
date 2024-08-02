import 'package:flutter/material.dart';
import 'package:flutter_cf_tube/component/custom_youtube_player.dart';
import 'package:flutter_cf_tube/model/video_model.dart';
import 'package:flutter_cf_tube/repository/youtube_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          centerTitle: true,
          title: FutureBuilder<List<VideoModel>>(
            future: YoutubeRepository.getVideos(),
            builder: (context, snapshot){
              if (snapshot.hasError){
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              }

              if (!snapshot.hasData){
                return Center(
                  child: Text(
                    'Youtube',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return Text(
                snapshot.data!.first.channelName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              );
            }
          ),
          backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<VideoModel>>(
        future: YoutubeRepository.getVideos(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return RefreshIndicator( // 새로고침 기능이 있는 위젯
            color: Colors.white,
            backgroundColor: Colors.black,
            onRefresh: () async{
              setState(() {});
            },
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data!.map((e) => CustomYoutubePlayer(videoModel: e)).toList(),
            ),
          );
        },
      ),
    );
  }
}
