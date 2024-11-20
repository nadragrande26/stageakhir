import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

class SpeakerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  RxString currentAudio = ''.obs;

  // Play audio from a local file path
  void playAudio(String filePath) async {
    // Play the audio from a local file
    await _audioPlayer.play(DeviceFileSource(filePath));
    currentAudio.value = filePath;
  }

  // Stop the currently playing audio
  void stopAudio() async {
    await _audioPlayer.stop();
  }

  // Let the user pick an audio file from their device
  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        playAudio(filePath); // Call playAudio to play the picked file
      }
    }
  }
}

class SpeakerScreen extends StatelessWidget {
  final SpeakerController speakerController = Get.put(SpeakerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speaker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text(
                speakerController.currentAudio.value.isNotEmpty
                    ? 'Playing: ${speakerController.currentAudio.value}'
                    : 'No audio playing',
                style: const TextStyle(fontSize: 24),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => speakerController.pickAudio(),
            child: const Text('Pick and Play Audio'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: speakerController.stopAudio,
            child: const Text('Stop Audio'),
          ),
        ],
      ),
    );
  }
}
