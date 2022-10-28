import 'package:equatable/equatable.dart';
import 'package:mocktest/models/Topics.dart';




abstract class LoadStudyTopicEvent extends Equatable {}


class LoadEvent extends LoadStudyTopicEvent{
  @override
  List<Topic> get props =>[];
}
