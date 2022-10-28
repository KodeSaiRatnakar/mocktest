import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktest/models/Topics.dart';
import 'package:mocktest/models/topic_event.dart';
import 'package:mocktest/models/topics_state.dart';

import 'apicall.dart';

class TopicsBloc extends Bloc<LoadStudyTopicEvent, TopicState> {
  TopicsBloc() : super(TopicLoadingState()) {
    on<LoadEvent>((event, emit) async {
      emit(TopicLoadingState());

      try {
        final topics = await ApiCall().getTopicsFromApi();


        emit(TopicsLoadedState(topics: topics));
      } catch (e) {
        emit(TopicsLoadedState(topics: [
          Topic(topicName: "sai", topics: ["ssgfda", "adff"])
        ]));
        print("error");
      }
    });
  }
}
