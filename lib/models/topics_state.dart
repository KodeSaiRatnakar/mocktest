
import 'package:equatable/equatable.dart';

import 'Topics.dart';

abstract class TopicState extends Equatable {}


class TopicLoadingState extends TopicState{
  @override
  List<Object?> get props =>[];
}


class TopicsLoadedState extends TopicState{
  final List<Topic> topics;

  TopicsLoadedState({required this.topics});

  @override
  List<Topic> get props => topics;
}