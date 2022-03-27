import 'dart:async';
import 'dart:io';
import 'package:final_620710653/model/quiz.dart';
import 'package:final_620710653/api/api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Quiz>? quiz_list;
  int sum = 0;
  int wrong_guess = 0;
  String message = "";

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('quizzes');
    setState(() {
      quiz_list = list.map((item) => Quiz.fromJson(item)).toList();
    });
  }

  void guess(String choice) {
    setState(() {
      if (quiz_list![sum].answer == choice) {
        message = "เก่งมากค่ะคุณผู้เล่น";
      } else {
        message = "ตอบผิดนะคะ ตอบใหม่ค่ะ";
      }
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        message = "";
        if (quiz_list![sum].answer == choice) {
          sum++;
        } else {
          wrong_guess++;
        }
      });
    });
  }

  Widget printGuess() {
    if (message.isEmpty) {
      return SizedBox(height: 20, width: 10);
    } else if (message == "เก่งมากค่ะคุณผู้เล่น") {
      return Text(message);
    } else {
      return Text(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quiz_list != null && sum < quiz_list!.length-1
          ? buildQuiz()
          : quiz_list != null && sum == quiz_list!.length-1
          ? buildTryAgain()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTryAgain() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('จบเกม'),
            Text('ทายผิด ${wrong_guess} ครั้ง'),

          ],
        ),
      ),
    );
  }

  Padding buildQuiz() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(quiz_list![sum].image_url, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < quiz_list![sum].choices.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(quiz_list![sum].choices[i].toString()),
                            child: Text(quiz_list![sum].choices[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            printGuess(),
          ],
        ),
      ),
    );
  }
}
