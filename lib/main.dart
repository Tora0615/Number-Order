import 'dart:async';
import 'package:flutter/material.dart';
import 'db.dart';
import 'history_score.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home' : (context) => MyHomePage(),
        '/recordPage': (context) => RecordPage(),
      },
      initialRoute: '/home',  //初始化頁面為Home
      //home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final dbHelper = DBHelper();


  // @override
  // void initState() {
  //   dbHelper.open();
  //   super.initState();
  // }


  getHistoryBest()async{
    double temp = (await dbHelper.getShortestTime())[0]['MIN(score)'];
    if (temp.runtimeType == Null){
      best = '0';
    }else{
      best = temp.toStringAsFixed(2);
    }
    dbLength = (await dbHelper.getLength())[0]['count(*)'];
    setState(() {});
  }

  initDBAndGetHistoryBest() async{
    await dbHelper.open();
    await getHistoryBest();
  }

  updateDataAndGetHistoryBest()async{
    //await dbHelper.insert(RecordHelper(id:dbLength+1,time:DateTime.now().toString().substring(0,19),score:useTime.toStringAsFixed(2)));
    await dbHelper.insert(RecordHelper(id:dbLength+1,time:DateTime.now().toString().substring(0,19),score:useTime));
    await getHistoryBest();
  }

  printDBDataToConsole()async{
    print('資料數目 : $dbLength');
    print(await dbHelper.getSortData());
  }

  deleteDBData(int id)async{
    try{
      await dbHelper.delete(id);
      dbLength = (await dbHelper.getLength())[0]['count(*)'];
      print('刪除成功，剩餘資料數目 : $dbLength');
      printDBDataToConsole();
    }catch (e){
      print('刪除失敗');
    }
  }


  //List numList = [1,2,3,4,5,6,7,8,9];
  List numList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
  List right = [];
  void shuffleNumList(){
    numList.shuffle();
  }

  int selectedCard = 100;
  bool gameStart = false;

  double gamingOpacity = 0;
  int count = 1;

  double setOpacity(int index){
    if(gameStart){
      if(right.contains(index)){ //包含
        return 1;
      }
      // else if(selectedCard == index){  //選中
      //   return 1;
      // }
      return 0;
    }else{
      return 0;
    }
  }

  double  wrongOpacity = 0;
  bool showPart = false;
  void showWrong(){
    wrongOpacity = 1;
    showPart = true;
    Timer(Duration(milliseconds:400), (){
      wrongOpacity = 0;
      setState(() {});
    });
    Timer(Duration(milliseconds:320), (){
      showPart = false;
      setState(() {});
    });
  }


  double startOpacity = 0;
  int countDownTime = 3;
  bool showAll = false;
  void showTwoSec(){
    startOpacity = 0;
    showAll = true;
    /*Timer 似乎是多線程OAO*/
    Timer(Duration(milliseconds:100), (){
      startOpacity = 1;
      setState(() {});
    });
    Timer(Duration(seconds:2), (){
      startOpacity = 0;
      setState(() {});
    });
    Timer(Duration(milliseconds: 2200), (){
      showAll = false;
      gameStart = true;
      setState(() {});
    });
  }

  double useTime = 0;
  String timeString = "0";
  bool needTiming=false;
  bool processing = false;
  bool lock = false;


  String best;
  RecordHelper recordHelper;
  int dbLength;

  test()async{
    /*錯誤，insert(e)的e是RecordHelper這個資料型態*/
    // List testList = [0000,'2020xxx',8.7];
    // testList.forEach((e) async => dbHelper.insert(e));
    // testList = [11111,'2020xxx',7.8];
    // testList.forEach((e) async => dbHelper.insert(e));

    /*更正版本(好讀)*/
    // recordHelper = RecordHelper(id:0000,time:'2020xxx',score:8.7);
    // await dbHelper.insert(recordHelper);
    // recordHelper = RecordHelper(id:0001,time:'2021xxx',score:7.8);
    // await dbHelper.insert(recordHelper);

    /*精簡版本(比較不好讀)*/
    // await dbHelper.insert(RecordHelper(id:0000,time:'2020xxx',score:8.7));
    // await dbHelper.insert(RecordHelper(id:0001,time:'2021xxx',score:7.8));


    // print (dbHelper.getLength()); //Instance of 'Future<dynamic>'
    // print (dbHelper.getSortData()); //Instance of 'Future<dynamic>'
    // => 大概要用Future or Future builder QwQ
    // => 用await就好

    /* dbHelper.getLength()是Instance of 'Future<dynamic>'，
    *  也就是說他"現在還沒辦法給你資料"，但"承諾未來一定會給你"，
    *  所以當直接 print(dbHelper.getSortData())時，
    *  印出來的不是要的資料。而解決方式就是 :
    *  在呼叫此Future Function時，在他之前加入await，
    *  其代表的意義是等待拿到資料之後再print。*/

    /* 然後 Future builder 似乎是 Future + builder 的鬼東東*/

    //print(await dbHelper.getLength());  //[{count(*): 2}]
    //print((await dbHelper.getLength())[0]['count(*)']);  //[{count(*): 2}]
    //
    print(best);
    print(await dbHelper.getSortData());  //[{id: 1, time: 2021xxx, score: 7.8}, {id: 0, time: 2020xxx, score: 8.7}]
    //
    // //print(await dbHelper.getShortestTime());  //印出 [{MIN(score): 7.8}]
    // print((await dbHelper.getShortestTime())[0]['MIN(score)']);  // 印出7.8
  }

  @override
  Widget build(BuildContext context) {
    initDBAndGetHistoryBest();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment : MainAxisAlignment.center,
                  children: <Widget>[
                    Text("已用時間 : ",),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "$timeString",
                      style: TextStyle(fontSize: 70),
                    ),
                    Text(
                      " sec",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("最佳成績 : $best sec"),
                  ],
                ),
                flex: 2,
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextButton.icon(
                          onPressed: (){
                            gameStart = false;
                            // print(useTime);
                            processing = false;
                            needTiming = false;
                            useTime = 0;
                            timeString = useTime.toStringAsFixed(0);
                            shuffleNumList();
                            selectedCard = 100;
                            right = [];
                            count = 1;
                            lock = false;
                            showTwoSec();
                            setState(() {});
                          },
                          icon: Icon(Icons.refresh),
                          label: Text("新一局"),
                      ),
                    ),
                    Expanded(
                        child: TextButton.icon(
                          onPressed: (){
                            gameStart = false;
                            setOpacity(10);
                            right = [];
                            count = 1;
                            processing = false;
                            needTiming = false;
                            test();
                            setState(() {});
                          },
                          icon: Icon(Icons.stop),
                          label: Text("停止"),
                        ),
                    ),
                    /*未來待實做*/
                    // Expanded(
                    //   flex: 1,
                    //   child: FlatButton.icon(
                    //       // onPressed: ()async{  //刪除DB專用
                    //       //   await printDBDataToConsole();
                    //       //   await deleteDBData(1);
                    //       // },
                    //       onPressed: (){
                    //         Navigator.pushNamed(context, '/recordPage');
                    //       },
                    //       icon: Icon(Icons.list),
                    //       label: Text("歷史紀錄"),
                    //   ),
                    //),
                  ],
                ),
              ),

              Expanded(
                flex: 14,
                child: AbsorbPointer(
                  absorbing: !gameStart || lock,
                  child: GridView.builder(
                      shrinkWrap: true, //important
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //crossAxisCount: 3,
                        crossAxisCount: 4,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      itemCount: numList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                            onPressed: (){
                              // print(count);
                              if(count == numList.length){ //9、16
                                needTiming = false;
                                processing = false;
                                lock = true;
                                updateDataAndGetHistoryBest();
                                getHistoryBest();
                                //test();
                              }else{
                                needTiming = true;
                              }
                              if(needTiming == true && processing != true){
                                processing = true;
                                Timer.periodic(Duration(milliseconds:10), (timerAdd){
                                  if(needTiming == false) {
                                    timerAdd.cancel();
                                    //print('canceled');  //OK
                                  }
                                  useTime += 0.01;
                                  timeString = useTime.toStringAsFixed(2);
                                  setState(() {});
                                });
                              }
                              selectedCard = index;
                              if(numList[index] == count){
                                right.add(index);
                                count+=1;
                              }else{  //選中且不同
                                showPart = true;
                                showWrong();
                              }
                              setState(() {});
                            },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.amber),
                            // https://www.cnblogs.com/r1cardo/p/15597022.html
                          ),
                            child: Center(
                              child: Opacity(
                                //opacity: showAll ? startOpacity : gamingOpacity,
                                //opacity: showAll ? startOpacity : setOpacity(index),
                                opacity: showAll ? startOpacity : (showPart ? (selectedCard == index ? wrongOpacity: setOpacity(index)) : setOpacity(index)),
                                child: Text(
                                  '${numList[index]}',
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                            ),
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
