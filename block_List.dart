//import 'dart:html';
import 'package:application_20221022/blockListfile.dart';
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
        '/myList' : (context) => my_List(),
        '/blacktList': (context) => block_List()
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

  static const routeName = '/blacktList';
  // 데이터 리스트
  static List<String> LoginuserEmail = [];
  static List<String> LoginuserName = [];
  static List<String> LoginuserStateMsg = [];

  static List<String> Friend_userEmail = [];
  static List<String> Friend_userName = [];

  String Email = '';
  String Friend_Read_Email = '', Friend_Read_Name = '';

  String Friend_Read_All = '';
  var Friend_Read_Userinfo = <String>[];

  static List<String> Friend_split_info = [];

  void initState(){

    getFriendInfo();
  }

  void getFriendInfo() async {
    LoginuserEmail.clear();
    LoginuserName.clear();
    LoginuserStateMsg.clear();

    Friend_userEmail.clear();
    Friend_userName.clear();

    final Friend_response = await http.get(Uri.parse(
        'http://www.teamtoktok.kro.kr/차단목록.php?user1='+widget.userEmail
    ));

    dom.Document document = parse.parse(Friend_response.body);

    setState(() {
      final Friend_Read_Msg = document.getElementsByClassName('blacktlist');

      Friend_Read_Userinfo = Friend_Read_Msg.map((element) => element.getElementsByTagName('tr')[0].innerHtml).toList();
      Friend_Read_All = Friend_Read_Userinfo[0].replaceAll(RegExp('(<td>|</td>)'), '');

      Friend_Read_Userinfo = Friend_Read_All.split('///');

      for(int i = 0; i < Friend_Read_Userinfo.length-1; i++){
        Friend_split_info = Friend_Read_Userinfo[i].split('::');
        Friend_Read_Email = Friend_split_info[0];
        Friend_Read_Name = Friend_split_info[1];

        LoginuserEmail.add(widget.userEmail.toString());
        LoginuserName.add(widget.userName.toString());
        LoginuserStateMsg.add(widget.userStateMsg.toString());

        Friend_userEmail.add(Friend_Read_Email.toString());
        Friend_userName.add(Friend_Read_Name.toString());
      }
    });
  }

 @override
  Widget build(BuildContext context){
    final List<blockListfile> userData = List.generate(Friend_userEmail.length, (index) =>
      blockListfile(LoginuserEmail[index], LoginuserName[index], LoginuserStateMsg[index], Friend_userEmail[index], Friend_userName[index]));

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
            onTap: () async {
              showDialog(context: context, builder: (context){
                  return Dialog(
                    child: Container(
                      width: 150, height: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              /*decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  color: Color(0xffC6C8C6),
                                  width: 1.5
                                ))
                              ),*/
                              alignment: Alignment.center,
                              width: double.infinity, height: double.infinity,
                              child: Text('친구 차단을 헤제하시겠습니까?')
                            )
                          ,flex:7),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity, height: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, '/blacktlist', arguments: BlockList_UserEmail(userEmail: widget.userEmail, userName: widget.userName, userStateMsg: widget.userStateMsg));
                                      }, child: Text('취소'),
                                    )
                                  )
                                ,flex:5),
                                Expanded(
                                  child: Container(
                                    width: double.infinity, height: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await http.get(Uri.parse('http://www.teamtoktok.kro.kr/차단목록.php?user1='+widget.userEmail+'&user2='+Friend_userEmail[index]));// 차단헤제
                                        print(Friend_userEmail[index]);
                                        print(widget.userEmail);
                                        //Navigator.pushNamed(context, '/blacktlist', arguments: BlockList_UserEmail(userEmail: widget.userEmail, userName: widget.userName, userStateMsg: widget.userStateMsg));
                                      },child: Text("확인"),
                                    )
                                  )
                                ,flex: 5,)
                              ]
                            )
                          ,flex:3)
                        ]
                     )
                   )
                  );
                }
              );
            },
              child: Card(
                child: Container(
                    width:100, height:70,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(userData[index].userName)
                  )
                )
              )
          );
        },
     )
   );
 }
}
