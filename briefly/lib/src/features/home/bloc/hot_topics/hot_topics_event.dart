import '../../../../domain/models/hot_topic_filter.dart';

abstract class HotTopicsEvent {}

class LoadHotTopics extends HotTopicsEvent {}

class ChangeFilter extends HotTopicsEvent {
  final HotTopicFilter filter;
  ChangeFilter(this.filter);
}

class ToggleFilters extends HotTopicsEvent {}
