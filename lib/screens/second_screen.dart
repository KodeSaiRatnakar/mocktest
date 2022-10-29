import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktest/database/database.dart';
import 'package:mocktest/models/topicBloc.dart';
import 'package:mocktest/models/topic_event.dart';
import 'package:mocktest/screens/home_screen.dart';

import '../models/Topics.dart';
import '../models/topics_state.dart';

TextEditingController mockTestName = TextEditingController();
ScrollController controller = ScrollController();

Map<int, bool> topic = {};
Map<int, Map<int, bool>> moreItemsSelect = {};

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    Size mediasize = MediaQuery.of(context).size;
    EdgeInsets sidePadding = const EdgeInsets.symmetric(horizontal: 45);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: mediasize.height * 0.05,
              ),
              Row(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.blueAccent,
                      )),
                  Spacer(
                    flex: 4,
                  ),
                  const Text(
                    "Create New Test",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 25),
                  ),
                  Spacer(
                    flex: 7,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: TextField(
                  controller: mockTestName,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.contacts,
                      color: Colors.blueAccent,
                    ),
                    hintText: "Test Name",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 45),
                child: Text(
                  "Topics",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: sidePadding,
                child: SizedBox(
                  height: 400,
                  child: BlocProvider(
                    create: (context) => TopicsBloc()..add(LoadEvent()),
                    child: BlocBuilder<TopicsBloc, TopicState>(
                        builder: (context, state) {
                      if (state is TopicLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return customListView(
                          state is TopicsLoadedState ? state.topics : [],
                          context);
                    }),
                  ),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    if (mockTestName.text.isNotEmpty) {
                      await LocalDataBase.writeData(mockTestName.text);
                    }

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                    mockTestName.clear();
                    topic = {};
                    moreItemsSelect = {};
                  },
                  child: Container(
                      width: mediasize.width * 0.6,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(9)),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "Create",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customListView(List<Topic> list, BuildContext context) {
  return ListView.builder(

    itemCount: list.length,
    itemBuilder: (context, index) {
      topic[index] ??= false;
      moreItemsSelect[index] ??= {};


      bool is_selected = false;
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            Row(
              children: [
                Checkbox(
                    side: const BorderSide(color: Colors.blueAccent, width: 2),
                    value: topic[index],
                    onChanged: (_) {
                      setState(() {
                        topic[index]!
                            ? topic[index] = false
                            : topic[index] = true;
                      });
                    }),
                FittedBox(
                    child: Text(
                  list[index].topicName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      setState(() {
                        is_selected ? is_selected = false : is_selected = true;



                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down))
              ],
            ),
            Visibility(
              visible: is_selected,
              child: SizedBox(
                  height: (55.0 * list[index].topics.length),
                  child: moreTopicListView(list[index].topics, context, index)),
            )
          ],
        );
      });
    },
  );
}

Widget moreTopicListView(
    List<String> list, BuildContext context, int parentIndex) {
  return ListView.builder(
      controller: controller,
      itemCount: list.length,
      itemBuilder: (context, index) {
        moreItemsSelect[parentIndex]![index] ??= false;

        return StatefulBuilder(builder: (context, setState) {
          return Row(
            children: [
              const SizedBox(
                width: 35,
              ),
              Checkbox(
                  focusColor: Colors.blueAccent,
                  activeColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent, width: 2),
                  value: moreItemsSelect[parentIndex]![index]!,
                  onChanged: (value) {
                    setState(() {
                      moreItemsSelect[parentIndex]![index]!
                          ? moreItemsSelect[parentIndex]![index] = false
                          : moreItemsSelect[parentIndex]![index] = true;

                    });
                  }),
              FittedBox(
                  child: Text(
                list[index],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              )),
            ],
          );
        });
      });
}
