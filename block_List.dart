
import 'package:application_20221022/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parse;
import 'package:application_20221022/my_List.dart';

class BlockList_UserEmail{
  final String userEmail;
  final String userName;
  final String userStateMsg;

  BlockList_UserEmail({required this.userEmail, required this.userName, required this.userStateMsg});
}

class block_List extends StatelessWidget {
  const block_List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usInfo = ModalRoute.of(context)?.settings.arguments as BlockList_UserEmail;

    return MaterialApp(
      routes: {
        '/myList' : (context) => my_List()
      },
      debugShowCheckedModeBanner: false,
      home: blockListPage(userEmail: usInfo.userEmail, userName: usInfo.userName, userStateMsg: usInfo.userStateMsg)
    );
  }
}

class blockListPage extends StatefulWidget {
  const blockListPage({Key? key, this.userEmail, this.userName, this.userStateMsg}) : super(key: key);
  final userEmail, userName, userStateMsg;

  @override
  State<blockListPage> createState() => _blockListPageState();
}

class _blockListPageState extends State<blockListPage> {

  static const routeName = '/friendList';
  // 데이터 리스트
  static List<String> LoginuserEmail = [];
  static List<String> LoginuserName = [];
  static List<String> LoginuserStateMsg = [];

  static List<String> Friend_userUID = [];
  static List<String> Friend_userEmail = [];
  static List<String> Friend_userName = [];
  static List<String> Friend_userImage = [];
  static List<String> Friend_userStateMsg = [];
  static List<String> Friend_userNickname = [];

  String Email = '';
  String Friend_Read_UID = '', Friend_Read_Email = '', Friend_Read_Name = '', Friend_Read_Image = '', Friend_Read_StateMsg = '', Friend_Read_Nickname = '';

  String Friend_Read_All = '';
  var Friend_Read_Userinfo = <String>[];

  static List<String> Friend_split_info = [];

  TextEditingController inputFriendEmail = TextEditingController();

  void initState(){

    getFriendInfo();
  }

  void getFriendInfo() async {
    LoginuserEmail.clear();
    LoginuserName.clear();
    LoginuserStateMsg.clear();

    Friend_userUID.clear();
    Friend_userEmail.clear();
    Friend_userName.clear();
    Friend_userImage.clear();
    Friend_userStateMsg.clear();
    Friend_userNickname.clear();

    final Friend_response = await http.get(Uri.parse(
        'http://www.teamtoktok.kro.kr/친구목록.php?user1=' + widget.userEmail
    ));

    dom.Document document = parse.parse(Friend_response.body);

    setState(() {
      final Friend_Read_Msg = document.getElementsByClassName('friendlist');

      Friend_Read_Userinfo = Friend_Read_Msg.map((element) => element.getElementsByTagName('tr')[0].innerHtml).toList();
      Friend_Read_All = Friend_Read_Userinfo[0].replaceAll(RegExp('(<td>|</td>)'), '');

      Friend_Read_Userinfo = Friend_Read_All.split('///');

      for(int i = 0; i < Friend_Read_Userinfo.length-1; i++){
        Friend_split_info = Friend_Read_Userinfo[i].split('::');
        Friend_Read_UID = Friend_split_info[0];
        Friend_Read_Email = Friend_split_info[1];
        Friend_Read_Name = Friend_split_info[2];
        Friend_Read_StateMsg = Friend_split_info[3];
        Friend_Read_Image = Friend_split_info[4];
        Friend_Read_Nickname = Friend_split_info[5];

        LoginuserEmail.add(widget.userEmail.toString());
        LoginuserName.add(widget.userName.toString());
        LoginuserStateMsg.add(widget.userStateMsg.toString());

        Friend_userUID.add(Friend_Read_UID.toString());
        Friend_userEmail.add(Friend_Read_Email.toString());
        Friend_userName.add(Friend_Read_Name.toString());
        Friend_userStateMsg.add(Friend_Read_StateMsg.toString());
        Friend_userImage.add(Friend_Read_Image.toString());
        Friend_userNickname.add(Friend_Read_Nickname.toString());
      }
    });
  }
  /*
  // 데이터리스트 배열
  static List<String> chatImage = [];
  static List<String> chatName = [];
  static List<String> chatMsg = [];
  static List<String> chatCount = [];
  static List<String> chatTime = [];
  static List<String> chatEmail = [];

  // 읽어들인 각각의 인덱스 값을 저장할 변수
  String Chat_Read_Image = '', Chat_Read_Name = '', Chat_Read_Msg = '', Chat_Read_Count = '', Chat_Read_Time = '', Chat_Read_Email = '';

  // 읽어들인 문자열을 저장할 변수
  String Chat_Read_All = '';

  // 읽어들인 것을 저장할 배열
  static List<String> Chat_Read_Info = [];

  // 구분자로 나누어 각각의 나눈 값을 삽입할 배열
  static List<String> Chat_Split_Info = [];

  // 채팅방을 추가할 때 검색할 텍스트 필드
  TextEditingController inputFriendName = TextEditingController();

  void initState(){
    getChatInfo();
  }

  void getChatInfo() async {
    // 혹시라도 배열에 값이 들어있는 것을 방지하기 위해 비워줌
    chatImage.clear();
    chatName.clear();
    chatMsg.clear();
    chatCount.clear();
    chatTime.clear();
    chatEmail.clear();

    // 채팅목록을 검색하기 위해 Url 실행
    final Chat_response =
    await http.get(Uri.parse('http://www.teamtoktok.kro.kr/친구목록.php?user1=' + widget.userEmail));

    // 문서... Url의 body에 접근을 할 것임
    dom.Document document = parse.parse(Chat_response.body);

    // setState() 함수 안에서의 호출은 State 에서 무언가 변경된 사항이 있음을 Flutter Framework에 알려주는 역할
    // 이로 인해 UI에 변경된 값이 반영될 수 있도록 build 메소드가 다시 실행된다.
    setState(() {
      // php 문서에서 className이 chatlist 아래에 있는 정보들을 가져와서 Read_Msg 변수에 저장
      final Read_Msg = document.getElementsByClassName('chatlist');

      // TagName이 tr 아래에 있는 값들을 모두 가져와서 저장
      Chat_Read_Info = Read_Msg.map((element) => element.getElementsByTagName('tr')[0].innerHtml).toList();

      // Chat_Read_Info 배열의 0번째 index 값의 문자열 중, <td> & </td> & <br>를 제거함
      Chat_Read_All = Chat_Read_Info[0].replaceAll('(<td>|</td>|<br>)', '');

      // Chat_Read_All 의 값을 구분자 '&'로 나누어 배열에 저장함
      Chat_Read_Info = Chat_Read_All.split('&');

      // 마지막 배열은 비어있을 것이기에 배열의 마지막에서 -1을 해줌
      for(int i = 0; i < Chat_Read_Info.length - 1; i++){
        // Chat_Read_Info 배열의 각 인덱스에 들어있는 값을 구분자 '::'로 나누어 배열에 집어넣음
        Chat_Split_Info = Chat_Read_Info[i].split('::');

        // 각 배열의 인덱스 값을 문자열에 저장 해줌
        Chat_Read_Image = Chat_Split_Info[0];
        Chat_Read_Name = Chat_Split_Info[1];
        Chat_Read_Msg = Chat_Split_Info[2];
        Chat_Read_Count = Chat_Split_Info[3];
        Chat_Read_Time = Chat_Split_Info[4];
        Chat_Read_Email = Chat_Split_Info[5];

        // 문자열을 각자의 배열에 삽입
        chatImage.add(Chat_Read_Image.toString());
        chatName.add(Chat_Read_Name.toString());
        chatMsg.add(Chat_Read_Msg.toString());
        chatCount.add(Chat_Read_Count.toString());
        chatTime.add(Chat_Read_Time.toString());
        chatEmail.add(Chat_Read_Email.toString());
      }
    });
  }
  */
 @override
  Widget build(BuildContext context){
   return Scaffold(
     resizeToAvoidBottomInset: false,
     appBar: AppBar(
       backgroundColor: Colors.white,
       leading: IconButton(
         onPressed: (){
           Navigator.pushNamed(context, '/myList', arguments: MyList_UserEmail(userEmail: widget.userEmail, userName: widget.userName, userStateMsg: widget.userStateMsg)); // 전체 목록 페이지로 이동 및 인자값 전달
         },
         icon: Icon(Icons.arrow_back, color: Colors.grey) // 뒤로가기 모양의 아이콘, 색상은 회색
       ),
       title: Text('차단친구 관리', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xff797979))) // 상단바에 텍스트로 '프로필 편집' 출력, 글자의 두께를 줄임
     ),
     body: ListView.builder(
        itemCount: Friend_userName.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              // 차단헤제
            }
          );
        },
     )
   );
 }
}
