import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  FlutterTts flutterTts = FlutterTts();
  String? chatgptcontent;
  String? dallEcontent;
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

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    // flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(
          child: const Text(
            'Pintoo',
            textAlign: TextAlign.center,
          ),
        ),
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
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
            ),
            const SizedBox(
              height: 20,
            ),
            FadeInLeft(
              child: Visibility(
                visible: dallEcontent == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: const Radius.circular(0.0),
                    ),
                  ),
                  child: chatgptcontent == null
                      ? const Text(
                          'Good morning, what task can I do for you?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        )
                      : Text(
                          chatgptcontent!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (dallEcontent != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(dallEcontent!)),
              ),
            Visibility(
              visible: chatgptcontent == null && dallEcontent == null,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SlideInLeft(
                        delay: const Duration(milliseconds: 200),
                        child: const Hint(
                            hintColor: Pallete.firstSuggestionBoxColor,
                            hintText: 'When is the world cup?'),
                      ),
                      SlideInRight(
                        delay: const Duration(milliseconds: 200),
                        child: const Hint(
                            hintColor: Pallete.secondSuggestionBoxColor,
                            hintText: 'Who is Allu Arjun?'),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SlideInLeft(
                        delay: const Duration(milliseconds: 300),
                        child: const Hint(
                            hintColor: Color.fromARGB(255, 167, 181, 242),
                            hintText: 'How are you?'),
                      ),
                      SlideInRight(
                        delay: const Duration(milliseconds: 300),
                        child: const Hint(
                            hintColor: Pallete.firstSuggestionBoxColor,
                            hintText: 'Who is Narendra Modi?'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SlideInLeft(
                        delay: const Duration(milliseconds: 400),
                        child: const Hint(
                            hintColor: Color.fromARGB(255, 167, 181, 242),
                            hintText: 'What is periods?'),
                      ),
                      // Hint(
                      //     hintColor: Pallete.firstSuggestionBoxColor,
                      //     hintText: 'Who is Narendra Modi?')
                    ],
                  ),
                ],
              ),
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
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          onPressed: () async {
            print('mic pressed');
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIServices.checkImageOrNot(lastWords);
              if (speech.contains('http')) {
                dallEcontent = speech;
                chatgptcontent = null;
                setState(() {});
              } else {
                chatgptcontent = speech;
                dallEcontent = null;
                setState(() {});
                await systemSpeak(speech);
              }

              await stopListening();
              // print('speech: ' + speech);
            } else {
              initSpeechToText();
            }
          },
          child: speechToText.isListening
              ? const Icon(Icons.stop)
              : const Icon(Icons.mic),
        ),
      ),
    );
  }
}
