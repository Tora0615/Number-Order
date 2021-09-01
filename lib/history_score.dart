import 'package:flutter/material.dart';
import 'db.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            AppBar(
              title: Text('歷史紀錄'),
              centerTitle: true,
              backgroundColor: Colors.amber,
            ),

          ],
        ),
      ),
    );
  }
}

