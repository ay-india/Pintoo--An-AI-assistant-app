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
  bool loading = false;
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String? chatgptcontent;
  String? dallEcontent;
  String lastWords = '';
  // String speech = '';
  TextEditingController searchController = TextEditingController();

  final AIServices openAIServices = AIServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    systemSpeak('');
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
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
    flutterTts.stop();
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
      body: Container(
        height: double.maxFinite,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
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
                              image: AssetImage(
                                  'assets/images/virtualAssistant.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //chat bubble
                  FadeInLeft(
                    child: Visibility(
                      visible: dallEcontent == null,
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Pallete.assistantCircleColor,
                            ))
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.circular(20).copyWith(
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
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Pallete.assistantCircleColor,
                            ),
                          )
                        : Padding(
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
                ],
              ),
            ),
            // SizedBox(
            //   height: 90,
            // ),
            Positioned(
              bottom: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 13),
                // color: Colors.red,
                height: 60,
                child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // TextField(
                      //   decoration: InputDecoration(border: OutlineInputBorder()),
                      // ),
                      Container(
                        // margin: EdgeInsets.all(10),
                        height: 50,
                        width: 300,
                        // color: Colors.blue,

                        child: TextField(
                          maxLines: 1,
                          controller: searchController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 6, bottom: 5, left: 12),
                            suffixIcon: InkWell(
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  systemSpeak('');
                                  print(searchController.text.toString());
                                  final speech = await openAIServices.chatGPT(
                                      searchController.text.toString());

                                  if (speech.contains('http')) {
                                    dallEcontent = speech;
                                    chatgptcontent = null;
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    chatgptcontent = speech;
                                    dallEcontent = null;
                                    setState(() {
                                      loading = false;
                                    });
                                    await systemSpeak(speech);
                                  }
                                },
                                child: Icon(Icons.search)),
                            filled: true,
                            fillColor: Pallete.assistantCircleColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Send a message...',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await systemSpeak("");
                          setState(() {
                            // loading = true;
                            searchController.text = '';
                          });

                          if (await speechToText.hasPermission &&
                              speechToText.isNotListening) {
                            await startListening();
                          } else if (speechToText.isListening) {
                            final speech =
                                await openAIServices.chatGPT(lastWords);
                            if (speech.contains('https')) {
                              dallEcontent = speech;
                              chatgptcontent = null;
                              setState(() {
                                dallEcontent = speech;
                                chatgptcontent = null;
                                loading = false;
                                searchController.text = lastWords;
                              });
                            } else {
                              chatgptcontent = speech;
                              dallEcontent = null;
                              setState(() {
                                chatgptcontent = speech;
                                dallEcontent = null;
                                loading = false;
                                searchController.text = lastWords;
                              });
                              await systemSpeak(speech);
                            }

                            await stopListening();
                            // print('speech: ' + speech);
                          } else {
                            initSpeechToText();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                14,
                              ),
                              color: Pallete.assistantCircleColor),
                          height: 50,
                          width: 50,
                          // width: ,
                          child: Center(child: Icon(Icons.mic)),
                        ),
                      )
                    ]),
                // width: 100,
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),

      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.symmetric(horizontal: 13),
      //   // color: Colors.red,
      //   height: 70,
      //   child:
      //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //     // TextField(
      //     //   decoration: InputDecoration(border: OutlineInputBorder()),
      //     // ),
      //     Container(
      //       // margin: EdgeInsets.all(10),
      //       height: 65,
      //       width: 300,
      //       // color: Colors.blue,

      //       child: TextField(
      //         maxLines: 1,
      //         controller: searchController,
      //         onChanged: (value) => setState(() {}),
      //         decoration: InputDecoration(
      //           border:
      //               OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      //           hintText: 'Send a message...',
      //         ),
      //       ),
      //     ),
      //     InkWell(
      //       onTap: () async {
      //         setState(() {
      //           loading = true;
      //         });
      //         systemSpeak('');
      //         print(searchController.text.toString());
      //         final speech = await openAIServices
      //             .chatGPT(searchController.text.toString());

      //         if (speech.contains('http')) {
      //           dallEcontent = speech;
      //           chatgptcontent = null;
      //           setState(() {
      //             loading = false;
      //           });
      //         } else {
      //           chatgptcontent = speech;
      //           dallEcontent = null;
      //           setState(() {
      //             loading = false;
      //           });
      //           await systemSpeak(speech);
      //         }
      //       },
      //       child: Container(
      //         padding: EdgeInsets.all(10),
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(
      //               14,
      //             ),
      //             color: Pallete.assistantCircleColor),
      //         height: 50,
      //         width: 50,
      //         // width: ,
      //         child: Center(child: Icon(Icons.search)),
      //       ),
      //     )
      //   ]),
      //   // width: 100,
      // ),
      // floatingActionButton: ZoomIn(
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       await systemSpeak("");
      //       // setState(() async {

      //       // });

      //       if (await speechToText.hasPermission &&
      //           speechToText.isNotListening) {
      //         await startListening();
      //       } else if (speechToText.isListening) {
      //         final speech = await openAIServices.checkImageOrNot(lastWords);
      //         if (speech.contains('https')) {
      //           dallEcontent = speech;
      //           chatgptcontent = null;
      //           setState(() {
      //             dallEcontent = speech;
      //             chatgptcontent = null;
      //           });
      //         } else {
      //           chatgptcontent = speech;
      //           dallEcontent = null;
      //           setState(() {
      //             chatgptcontent = speech;
      //             dallEcontent = null;
      //           });
      //           await systemSpeak(speech);
      //         }

      //         await stopListening();
      //         // print('speech: ' + speech);
      //       } else {
      //         initSpeechToText();
      //       }
      //     },
      //     child: speechToText.isListening
      //         ? const Icon(Icons.stop)
      //         : const Icon(Icons.mic),
      //   ),
      // ),
    );
  }
}
