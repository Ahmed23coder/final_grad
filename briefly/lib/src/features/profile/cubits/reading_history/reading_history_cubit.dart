import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/models/news_article.dart';
import '../../../../domain/repositories/news_repository.dart';
import 'reading_history_state.dart';

class ReadingHistoryCubit extends Cubit<ReadingHistoryState> {
  final NewsRepository _newsRepository;

  ReadingHistoryCubit(this._newsRepository) : super(const ReadingHistoryState());

  Future<void> loadHistory() async {
    emit(state.copyWith(status: ReadingHistoryStatus.loading));
    try {
      final history = await _newsRepository.getReadingHistory();
      
      if (history.isEmpty) {
        emit(state.copyWith(status: ReadingHistoryStatus.empty));
        return;
      }

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final yesterdayStart = todayStart.subtract(const Duration(days: 1));

      final todayList = <NewsArticle>[];
      final yesterdayList = <NewsArticle>[];
      final earlierList = <NewsArticle>[];

      for (final article in history) {
        final readAt = article.lastReadAt ?? article.publishedAt;
        if (!readAt.isBefore(todayStart)) {
          todayList.add(article);
        } else if (!readAt.isBefore(yesterdayStart)) {
          yesterdayList.add(article);
        } else {
          earlierList.add(article);
        }
      }

      final grouped = <HistorySection, List<NewsArticle>>{};
      if (todayList.isNotEmpty) grouped[HistorySection.today] = todayList;
      if (yesterdayList.isNotEmpty) grouped[HistorySection.yesterday] = yesterdayList;
      if (earlierList.isNotEmpty) grouped[HistorySection.earlier] = earlierList;

      emit(state.copyWith(
        status: ReadingHistoryStatus.success,
        groupedHistory: grouped,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReadingHistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}



