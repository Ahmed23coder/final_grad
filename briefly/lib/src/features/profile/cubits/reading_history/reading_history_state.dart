import 'package:equatable/equatable.dart';
import '../../../../domain/models/news_article.dart';

enum HistorySection { today, yesterday, earlier }

enum ReadingHistoryStatus { initial, loading, success, empty, error }

class ReadingHistoryState extends Equatable {
  final ReadingHistoryStatus status;
  final Map<HistorySection, List<NewsArticle>> groupedHistory;
  final String? errorMessage;

  const ReadingHistoryState({
    this.status = ReadingHistoryStatus.initial,
    this.groupedHistory = const {},
    this.errorMessage,
  });

  bool get isLoading => status == ReadingHistoryStatus.loading;
  bool get isEmpty => status == ReadingHistoryStatus.empty;

  ReadingHistoryState copyWith({
    ReadingHistoryStatus? status,
    Map<HistorySection, List<NewsArticle>>? groupedHistory,
    String? errorMessage,
  }) {
    return ReadingHistoryState(
      status: status ?? this.status,
      groupedHistory: groupedHistory ?? this.groupedHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, groupedHistory, errorMessage];
}



