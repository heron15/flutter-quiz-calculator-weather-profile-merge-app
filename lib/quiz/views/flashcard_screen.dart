import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:four_in_one_app/material/color.dart';
import 'dart:math';

import 'package:four_in_one_app/quiz/views/quiz_screen.dart';

class NewCard extends StatefulWidget {
  final String topicName;
  final List<dynamic> typeOfTopic;
  const NewCard(
      {super.key, required this.topicName, required this.typeOfTopic});

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  Widget build(BuildContext context) {
    const Color bgColor3 = Colors.white;
    const Color cardColor = mainColor;

    // Get a list of 4 randomly selected Questions objects
    Map<dynamic, dynamic> randomQuestionsMap =
        getRandomQuestionsAndOptions(widget.typeOfTopic, 4);

    List<dynamic> randomQuestions = randomQuestionsMap.keys.toList();
    dynamic randomOptions = randomQuestionsMap.values.toList();

    return Scaffold(
      backgroundColor: bgColor3,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(cardColor),
                  fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.85, 60),
                  ),
                  elevation: MaterialStateProperty.all(4),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        questionlenght: randomQuestions,
                        optionsList: randomOptions,
                        topicType: widget.topicName,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Start Quiz",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Map<dynamic, dynamic> getRandomQuestionsAndOptions(
  List<dynamic> allQuestions,
  int count,
) {
  final randomQuestions = <dynamic>[];
  final randomOptions = <dynamic>[];
  final random = Random();

  if (count >= allQuestions.length) {
    count = allQuestions.length;
  }

  while (randomQuestions.length < count) {
    final randomIndex = random.nextInt(allQuestions.length);
    final selectedQuestion = allQuestions[randomIndex];

    if (!randomQuestions.contains(selectedQuestion)) {
      randomQuestions.add(selectedQuestion);
      randomOptions.add(selectedQuestion.options);
    }
  }

  return Map.fromIterables(randomQuestions, randomOptions);
}
