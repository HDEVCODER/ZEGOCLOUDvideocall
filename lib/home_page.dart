import 'dart:developer';
import 'dart:math' as math;

import 'package:easy_example_flutter/model/call_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:easy_example_flutter/zego_express_manager.dart';

final List<Call> calls = [
  // face
  Call(number: '423456', date: "2022/8/12", color: Colors.green)
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // change by using your app id from your console
  final int appID = 2138559609;
  final formKey = GlobalKey<FormState>();
  final String appSign =
      'c25b01b85bd79e719e6ae82179084df23f9d3ecb94cf7c014e12d8663453553c';
  final TextEditingController roomIDController = TextEditingController();

  /// Check the permission or ask for the user if not grant

  Future<bool> requestPermission(ZegoMediaOptions options) async {
    if (options.contains(ZegoMediaOption.publishLocalAudio)) {
      PermissionStatus microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus != PermissionStatus.granted) {
        log('Error: Microphone permission not granted!!!');
      }
    }

    if (options.contains(ZegoMediaOption.publishLocalVideo)) {
      PermissionStatus cameraStatus = await Permission.camera.request();
      if (cameraStatus != PermissionStatus.granted) {
        log('Error: Camera permission not granted!!!');
      }
    }
    return true;
  }

  /// Get the necessary arguments to join the room for start the talk or live streaming
  ///
  ///  TODO DO NOT use special characters for userID and roomID.
  ///  We recommend only contain letters, numbers, and '_'.
  Future<Map<String, String>> getJoinRoomArgs(String roomID) async {
    final userID = math.Random().nextInt(10000).toString();
    return {
      'userID': userID,
      'roomID': roomID.toString(),
      'appID': appID.toString(),
      'appSign': appSign.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'ZEGOCLOUD',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () async {
                  await requestPermission([ZegoMediaOption.publishLocalVideo]);
                  Navigator.pushReplacementNamed(context, '/video_call_page',
                      arguments: await getJoinRoomArgs(calls[index].number));
                  setState(() {
                    calls.add(Call(
                        color: Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
                        number: calls[index].number,
                        date: DateTime.now().year.toString() +
                            "/" +
                            DateTime.now().month.toString() +
                            "/" +
                            DateTime.now().day.toString()));
                  });
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: calls[index].color,
                        child: Text(calls[index].number.characters.first)),
                    title: Text(calls[index].number),
                    trailing: Text(calls[index].date),
                  ),
                ),
              );
            }),
            itemCount: calls.length,
          ),
        ),
        floatingActionButton: ElevatedButton.icon(
          icon: const Icon(Icons.video_call),
          label: const Text('New'),
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12))),
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text(
                    'Inter The Room Id'), // To display the title it is optional
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: roomIDController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Room Id',
                      hintText: 'Enter Room Id',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'hey bro dont leave it empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          roomIDController.clear();
                        });
                      },
                      child: const Text('Cancle')),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${roomIDController.text} Joining'),
                            backgroundColor: Colors.green,
                          ));

                          await requestPermission(
                              [ZegoMediaOption.publishLocalVideo]);

                          Navigator.pushReplacementNamed(
                              context, '/video_call_page',
                              arguments:
                                  await getJoinRoomArgs(roomIDController.text));
                          setState(() {
                            calls.add(Call(
                                color: Color(
                                        (math.Random().nextDouble() * 0xFFFFFF)
                                            .toInt())
                                    .withOpacity(1.0),
                                number: roomIDController.text,
                                date: DateTime.now().year.toString() +
                                    "/" +
                                    DateTime.now().month.toString() +
                                    "/" +
                                    DateTime.now().day.toString()));
                          });
                        }
                      },
                      icon: const Icon(Icons.video_call),
                      label: const Text('Call')),
                ],
              ),
            );
          },
        ));
  }
}
