import 'package:flutter/material.dart';
import 'package:application_20221022/my_List.dart';

class appVersion_UserEmail{ // 로그인한 사용자의 이메일 정보를 담아둘 클래스 객체 선언
  final String userEmail;
  final String userName;
  final String userStateMsg;

  appVersion_UserEmail({required this.userEmail, required this.userName, required this.userStateMsg});
}

class app_Version extends StatelessWidget {
  const app_Version({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final usInfo = ModalRoute.of(context)?.settings.arguments as appVersion_UserEmail; // MyList_UserEmail 클래스에 들어있는 인자값을 가져오기 위함

    return MaterialApp(
        routes: {
          '/myList' : (context) => my_List(), // MyApp 페이지로 값을 넘겨주기 위함
        },
        debugShowCheckedModeBanner: false,
        home: appVersionPage(userEmail: usInfo.userEmail, userName: usInfo.userName, userStateMsg: usInfo.userStateMsg)
    );
  }
}

class appVersionPage extends StatefulWidget {
  const appVersionPage({Key? key, this.userEmail, this.userName, this.userStateMsg}) : super(key: key);
  final userEmail, userName, userStateMsg;

  @override
  State<appVersionPage> createState() => _appVersionPageState();
}

class _appVersionPageState extends State<appVersionPage> {

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
            title: Text('앱버전', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xff797979))) // 상단바에 텍스트로 '프로필 편집' 출력, 글자의 두께를 줄임
        ),
      body: Container(
        child:Column(
          children:[
            Expanded(
                child: Container(
            ),flex:1),
            Expanded(
                child: Container(
                    child: Text('버전명', style: TextStyle(fontSize:50, fontWeight: FontWeight.bold, color: Colors.black))// 상단바에 텍스트로 '프로필 편집' 출력, 글자의 두께를 줄임
            ),flex:1),
            Expanded(
                child: Container(
            ),flex:1)
          ]
        )
      ),
    );
  }
}

