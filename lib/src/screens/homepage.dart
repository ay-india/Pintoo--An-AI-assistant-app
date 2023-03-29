import 'package:flutter/material.dart';
import 'package:pintu/src/services/open_api_services.dart';
import 'package:pintu/src/utils/pallete.dart';
import 'package:pintu/src/widgets/hint.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  String lastWords = '';
  // String speech = '';

  final AIServices openAIServices = AIServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pintoo',
          textAlign: TextAlign.center,
        ),
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/virtualAssistant.png'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: const Radius.circular(0.0),
                ),
              ),
              child: const Text(
                'Good morning, what task can I do for you?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Hint(
                    hintColor: Pallete.firstSuggestionBoxColor,
                    hintText: 'When is the world cup?'),
                Hint(
                    hintColor: Pallete.secondSuggestionBoxColor,
                    hintText: 'Who is Allu Arjun?')
              ],
            ),
            // SizedBox(
            //   height: 15,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Hint(
                    hintColor: Color.fromARGB(255, 167, 181, 242),
                    hintText: 'How are you?'),
                Hint(
                    hintColor: Pallete.firstSuggestionBoxColor,
                    hintText: 'Who is Narendra Modi?')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Hint(
                    hintColor: Color.fromARGB(255, 167, 181, 242),
                    hintText: 'What is periods?'),
                // Hint(
                //     hintColor: Pallete.firstSuggestionBoxColor,
                //     hintText: 'Who is Narendra Modi?')
              ],
            ),
            IconButton(
              onPressed: () {
                print(lastWords);
                // print("speech: $speech");
              },
              icon: Icon(Icons.print_rounded),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIServices.checkImageOrNot(lastWords);
            print(speech);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
