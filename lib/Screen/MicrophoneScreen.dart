import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class MicrophoneController extends GetxController {
  final SpeechToText _speech = SpeechToText();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  RxString recognizedText = "".obs;
  RxBool isListening = false.obs;
  RxBool isRecording = false.obs;
  String? audioPath;

  @override
  void onInit() {
    super.onInit();
    _initializeRecorder();
  }

  // Initialize the recorder
  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  // Start listening for speech-to-text
  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (result) {
        recognizedText.value = result.recognizedWords;
      });
      isListening.value = true;
    }
  }

  // Stop speech-to-text listening
  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  // Start recording audio
  void startRecording() async {
    final directory = await Directory.systemTemp.createTemp();
    audioPath = '${directory.path}/recording.aac';
    await _recorder.startRecorder(toFile: audioPath);
    isRecording.value = true;
  }

  // Stop recording audio
  void stopRecording() async {
    await _recorder.stopRecorder();
    isRecording.value = false;
  }

  // Play the recorded audio
  void playRecording() {
    if (audioPath != null) {
      _audioPlayer.play(DeviceFileSource(audioPath!));
    }
  }
}

class MicrophoneScreen extends StatelessWidget {
  final MicrophoneController microphoneController = Get.put(MicrophoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microphone')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(microphoneController.recognizedText.value, style: const TextStyle(fontSize: 24))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (microphoneController.isListening.value) {
                  microphoneController.stopListening();
                } else {
                  microphoneController.startListening();
                }
              },
              child: Obx(() => Text(microphoneController.isListening.value ? 'Stop Listening' : 'Start Listening')),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (microphoneController.isRecording.value) {
                  microphoneController.stopRecording();
                } else {
                  microphoneController.startRecording();
                }
              },
              child: Obx(() => Text(microphoneController.isRecording.value ? 'Stop Recording' : 'Start Recording')),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                microphoneController.playRecording();
              },
              child: const Text('Play Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
