
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parse;
import 'package:application_20221022/my_List.dart';

class profile_edit_UserEmail{
  final String userEmail;
  final String userName;
  final String userStateMsg;

  profile_edit_UserEmail({required this.userEmail, required this.userName, required this.userStateMsg });
}

class profile_edit extends StatelessWidget {
  const profile_edit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usInfo = ModalRoute.of(context)?.settings.arguments as profile_edit_UserEmail;

    return MaterialApp(
      routes:{
        '/myList' : (context) => my_List()
      },
      debugShowCheckedModeBanner : false,
      home: profileEditPage(userEmail: usInfo.userEmail, userName: usInfo.userName, userStateMsg: usInfo.userStateMsg)
    );
  }
}

class profileEditPage extends StatefulWidget {
  const profileEditPage({Key? key, this.userEmail, this.userName, this.userStateMsg}): super(key: key);
  final userEmail, userName, userStateMsg;

  @override
  State<profileEditPage> createState() => _profileEditPageState();
}

class _profileEditPageState extends State<profileEditPage> {

  // 프로필 이름, 상태메시지 변경 시 입력한 이름과 상태메시지 값을 저장할 변수
  TextEditingController edit_inputName = TextEditingController();
  TextEditingController edit_inputStateMsg = TextEditingController();
  // 데이터리스트 배열
  static List<String> chatImage = [];
  static List<String> chatName = [];
  static List<String> chatMsg = [];
  static List<String> chatCount = [];
  static List<String> chatTime = [];

  // 읽어들인 각각의 인덱스 값을 저장할 변수
  String Chat_Read_Image = '', Chat_Read_Name = '', Chat_Read_Msg = '', Chat_Read_Count = '', Chat_Read_Time = '';

  // 읽어들인 문자열을 저장할 변수
  String Chat_Read_All = '';

  // 읽어들인 것을 저장할 배열
  static List<String> Chat_Read_Info = [];

  // 구분자로 나누어 각각의 나눈 값을 삽입할 배열
  static List<String> Chat_Split_Info = [];

  // 채팅방을 추가할 때 검색할 텍스트 필드
  //TextEditingController inputFriendName = TextEditingController();

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

    // 채팅목록을 검색하기 위해 Url 실행
    final Chat_response =
    await http.get(Uri.parse('http://www.teamtoktok.kro.kr/채팅방목록.php?user=' + widget.userEmail));

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

        // 문자열을 각자의 배열에 삽입
        chatImage.add(Chat_Read_Image.toString());
        chatName.add(Chat_Read_Name.toString());
        chatMsg.add(Chat_Read_Msg.toString());
        chatCount.add(Chat_Read_Count.toString());
        chatTime.add(Chat_Read_Time.toString());
      }
    });
  }

  String Nickname="", State="";

  @override
  Widget build(BuildContext context) {
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
          title: Text('프로필 편집', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xff797979))) // 상단바에 텍스트로 '프로필 편집' 출력, 글자의 두께를 줄임
      ),
      body: Container(
        child:Column(
          mainAxisSize: MainAxisSize.max, // 남은 영역을 모두 사용
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 일정 간격을 두고 정렬
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container( // 가운데 왼쪽으로 정렬
                width: double.infinity, height: 50, // 가로 무제한, 세로 60
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide( // 박스 위젯의 아래 테두리에 색을 주기 위함
                        width: 1.5,
                        color: Color(0xffC6C8C6)
                    ))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: ElevatedButton( // 이미지 버튼 위젯
                      onPressed: () async {

                      },
                      child: Text('이미지 변경', style: TextStyle(color: Colors.black, fontSize: 16)) // 볼드체, 크기 16, 색상 검정
                  ),
                )
            ),flex: 3),
            Expanded(child: Container(
              child:Padding(
                  padding: EdgeInsets.fromLTRB(30 , 0, 30, 0),
                  child: Text('프로필 이름 변경', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20)) // 상단바에 텍스트로 '프로필 편집' 출력, 글자의 두께를 줄임
              )
            ),flex: 1),
            Expanded(child: Container(
                width: double.infinity, height: 50, // 가로 무제한, 세로 70
                child:Padding(
                    padding: EdgeInsets.fromLTRB(30 , 0, 30, 20),
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: edit_inputName,
                      decoration: InputDecoration(
                        hintText: '변경할 프로필 이름을 입력해주세요.',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xffC6C8C6)
                          )
                        ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffC6C8C6)
                              )
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffC6C8C6)
                              )
                          ),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffC6C8C6)
                              )
                          )
                      ),
                    )
                )
            ),flex: 2),
            Expanded(child: Container( // 가운데 왼쪽으로 정렬
                width: double.infinity, height: 50, // 가로 무제한, 세로 60
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: ElevatedButton( // 텍스트 버튼 위젯
                      onPressed: () async {
                        setState(() {
                          Nickname=edit_inputName.text;
                        });
                        await http.get(Uri.parse('http://www.teamtoktok.kro.kr/내이름변경.php?user1='+widget.userEmail+'&Nickname='+Nickname)); // 닉네임변경
                        //http://www.teamtoktok.kro.kr/이름변경.php?user=Leeeunsoo&name=leeeunsu2 //이름변경시
                      },
                      child: Text('이름 변경', style: TextStyle(color: Colors.black, fontSize: 16)) // 볼드체, 크기 16, 색상 검정
                  ),
                )
            ),flex: 2),
            Expanded(child: Container(
              child:Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text('상태메시지 변경' ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20)) // 상단바에 텍스트로 '프로필 편집' 출력, 글자의 두께를 줄임
              )
            ),flex: 1),
            Expanded(child: Container(
                width: double.infinity, height: 50, // 가로 무제한, 세로 70
                child:Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: TextField(
                      textAlign: TextAlign.left,
                      controller: edit_inputStateMsg,
                      decoration: InputDecoration(
                          hintText: '변경할 상태메시지를 입력해주세요.',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffC6C8C6)
                              )
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffC6C8C6)
                              )
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffC6C8C6)
                              )
                          ),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xffC6C8C6)
                              )
                          )
                      ),
                    )
                )
            ),flex: 3),
            Expanded(child: Container( // 가운데 왼쪽으로 정렬
                width: double.infinity, height: 50, // 가로 무제한, 세로 60
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: ElevatedButton( // 텍스트 버튼 위젯
                      onPressed: () async {
                        setState(() {
                          State=edit_inputStateMsg.text;
                        });
                        await http.get(Uri.parse('http://www.teamtoktok.kro.kr/상태메세지변경.php?user='+widget.userEmail+'&statemessage='+State));
                      },
                     child: Text('상태메시지 변경', style: TextStyle(color: Colors.black, fontSize: 16)) // 볼드체, 크기 16, 색상 검정
                  ),
                )
            ),flex: 2),
            Expanded(child: Container(

            ),flex: 5)
          ]
        )
      )
    );
  }
}
