//import 'dart:html';
import 'package:application_20221022/NewsListfile.dart';
import 'package:application_20221022/blockListfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parse;
import 'package:application_20221022/my_List.dart';
import 'dart:async';
import 'dart:io';

class NewsList_UserEmail{
  final String userEmail;
  final String userName;
  final String userStateMsg;

  NewsList_UserEmail({required this.userEmail, required this.userName, required this.userStateMsg});
}



class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usInfo = ModalRoute.of(context)?.settings.arguments as NewsList_UserEmail;

    return MaterialApp(
        routes: {
          '/myList' : (context) => my_List(),
        },
        debugShowCheckedModeBanner: false,
        home: NewsListPage(userEmail: usInfo.userEmail, userName: usInfo.userName, userStateMsg: usInfo.userStateMsg)
    );
  }
}

class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key, this.userEmail, this.userName, this.userStateMsg}) : super(key: key);
  final userEmail, userName, userStateMsg;

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {

  static const routeName = '/NewsList';
  // 데이터 리스트
  static List<String> LoginuserEmail = [];
  static List<String> LoginuserName = [];
  static List<String> LoginuserStateMsg = [];

  static List<String> News_Uid = [];
  static List<String> News_Title = [];
  static List<String> News_Contents = [];
  static List<String> News_Time = [];

  String Email = '';
  String News_Read_Uid='';
  String News_Read_Title='';
  String News_Read_Contents='';
  String News_Read_Time='';

  String News_Read_All = '';
  var News_Read_Userinfo = <String>[];

  static List<String> News_split_info = [];

  void initState(){
    super.initState();
    getFriendInfo();
  }

  void getFriendInfo() async {
    LoginuserEmail.clear();
    LoginuserName.clear();
    LoginuserStateMsg.clear();

    News_Uid.clear();
    News_Title.clear();
    News_Contents.clear();
    News_Time.clear();

    final News_response = await http.get(Uri.parse(
        'http://www.teamtoktok.kro.kr/공지사항.php?'
    ));

    dom.Document document = parse.parse(News_response.body);

    setState(() {
      final News_Read_Msg = document.getElementsByClassName('notice');

      News_Read_Userinfo = News_Read_Msg.map((element) => element.getElementsByTagName('tr')[0].innerHtml).toList();
      News_Read_All = News_Read_Userinfo[0].replaceAll(RegExp('(<td>|</td>)'), '');

      News_Read_Userinfo = News_Read_All.split('///');

      for(int i = 0; i < News_Read_Userinfo.length-1; i++){
        News_split_info = News_Read_Userinfo[i].split('::');
        News_Read_Uid = News_split_info[0];
        News_Read_Title = News_split_info[1];
        News_Read_Contents = News_split_info[2];
        News_Read_Time = News_split_info[3];

        LoginuserEmail.add(widget.userEmail.toString());
        LoginuserName.add(widget.userName.toString());
        LoginuserStateMsg.add(widget.userStateMsg.toString());

        News_Uid.add(News_Read_Uid.toString());
        News_Title.add(News_Read_Title.toString());
        News_Contents.add(News_Read_Contents.toString());
        News_Time.add(News_Read_Time.toString());
      }
    });
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Do you want to exit?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
    return false;
  }

  ooon(){
    return WillPopScope(child: TextButton(onPressed: () async {
      await launch('tel:11111111111'); // String 형으로 ('tel:'+전화번호) 넣으면 됩니다
    },
    child: Text("call")), onWillPop: (){SystemNavigator.pop(); return Future.value(false);}); // 뒤로가기 버튼 활성화인데 작동안됨
  }

  @override
  Widget build(BuildContext context){
    List<NewsListfile> userData = List.generate(News_Read_Uid.length, (index) =>
         NewsListfile(LoginuserEmail[index], LoginuserName[index], LoginuserStateMsg[index], News_Uid[index], News_Title[index], News_Contents[index], News_Time[index]));
    String c="sad";
    return ooon(/*WillPopScope(child: Text(c), onWillPop: (){
      return Future(() => false);
    }*/
    /*,
        child:Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/myList', arguments: MyList_UserEmail(userEmail: widget.userEmail, userName: widget.userName, userStateMsg: widget.userStateMsg)); // 전체 목록 페이지로 이동 및 인자값 전달
              },
              icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 모양의 아이콘, 색상은 회색
            ),
            title: Text('공지사항', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xff797979))) // 상단바에 텍스트로 '프로필 편집' 출력, 글자의 두께를 줄임
          ),
          body: Center(
              child: Container(
                child: Text("..")
              )
          )
      )*/
    );
  }
}
