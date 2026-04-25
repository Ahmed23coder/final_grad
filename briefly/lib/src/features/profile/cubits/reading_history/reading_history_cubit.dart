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

      // Grouping logic (Today, Yesterday, Earlier)
      // For this implementation, we manually split the list
      // In a real app, this would use DateTime comparison
      final today = history.take(2).toList();
      final yesterday = history.skip(2).take(2).toList();
      final earlier = history.skip(4).toList();

      final grouped = <HistorySection, List<NewsArticle>>{};
      if (today.isNotEmpty) grouped[HistorySection.today] = today;
      if (yesterday.isNotEmpty) grouped[HistorySection.yesterday] = yesterday;
      if (earlier.isNotEmpty) grouped[HistorySection.earlier] = earlier;

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



