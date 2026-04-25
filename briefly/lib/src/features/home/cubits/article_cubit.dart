import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:briefly/src/domain/repositories/news_repository.dart';
import '../../../domain/models/news_article.dart';
import 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final NewsRepository _repository;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isTtsInitialized = false;
  int _speedIndex = 2;

  ArticleCubit(this._repository) : super(const ArticleState());

  Future<void> _ensureTtsInitialized() async {
    if (_isTtsInitialized) return;

    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      _flutterTts.setCompletionHandler(() {
        _onParagraphComplete();
      });

      _isTtsInitialized = true;
    } catch (e) {
      developer.log('TTS init failed', name: 'tts', error: e);
    }
  }

  void _onParagraphComplete() {
    if (isClosed) return;
    if (state.article != null && state.isPlaying) {
      final paragraphs = state.article!.content.split('\n\n');
      if (state.currentParagraphIndex < paragraphs.length - 1) {
        nextParagraph(paragraphs.length);
      } else {
        emit(state.copyWith(isPlaying: false, isReadingAloud: false));
      }
    }
  }

  Future<void> loadArticle(String id, {NewsArticle? initialArticle}) async {
    if (initialArticle != null) {
      emit(state.copyWith(
        isLoading: false,
        article: initialArticle,
        clearError: true,
      ));
      unawaited(
        _repository.addToReadingHistory(initialArticle).catchError((Object e) {
          developer.log(
            'addToReadingHistory failed',
            name: 'article',
            error: e,
          );
        }),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final article = await _repository.getArticleById(id);
      emit(state.copyWith(
        isLoading: false,
        article: article,
      ));
      unawaited(
        _repository.addToReadingHistory(article).catchError((Object e) {
          developer.log(
            'addToReadingHistory failed',
            name: 'article',
            error: e,
          );
        }),
      );
    } catch (e, st) {
      developer.log('Article load failed', name: 'article', error: e, stackTrace: st);
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load article. Please try again.',
      ));
    }
  }

  Future<void> summarizeArticle() async {
    if (state.article == null || state.isSummarizing) return;

    emit(state.copyWith(isSummarizing: true));

    try {
      final summary = await _repository.summarizeArticle(state.article!.content);
      emit(state.copyWith(
        isSummarizing: false,
        aiSummary: summary,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSummarizing: false,
        error: 'Failed to generate AI summary',
      ));
    }
  }

  void toggleSaved() {
    emit(state.copyWith(isSaved: !state.isSaved));
  }

  void toggleReadAloud() {
    if (state.isReadingAloud) {
      _stopReading();
      emit(state.copyWith(
        isReadingAloud: false,
        isPlaying: false,
      ));
    } else {
      emit(state.copyWith(
        isReadingAloud: true,
        isPlaying: true,
        currentParagraphIndex: 0,
      ));
      _startReading();
    }
  }

  void _startReading() {
    _ensureTtsInitialized().then((_) {
      _speakCurrentParagraph();
    });
  }

  void _speakCurrentParagraph() {
    if (state.article == null) return;
    final paragraphs = state.article!.content.split('\n\n');
    if (state.currentParagraphIndex < paragraphs.length) {
      final text = paragraphs[state.currentParagraphIndex];
      _flutterTts.setSpeechRate(state.playbackSpeed / 2);
      _flutterTts.speak(text);
    }
  }

  void _stopReading() {
    _flutterTts.stop();
  }

  void closeReadAloud() {
    _stopReading();
    emit(state.copyWith(
      isReadingAloud: false,
      isPlaying: false,
    ));
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      _stopReading();
      emit(state.copyWith(isPlaying: false));
    } else {
      emit(state.copyWith(isPlaying: true));
      _startReading();
    }
  }

  void cycleSpeed() {
    _speedIndex = (_speedIndex + 1) % state.availableSpeeds.length;
    final newSpeed = state.availableSpeeds[_speedIndex];
    emit(state.copyWith(playbackSpeed: newSpeed));
    if (state.isPlaying) {
      _speakCurrentParagraph();
    }
  }

  void previousParagraph() {
    if (state.currentParagraphIndex > 0) {
      emit(state.copyWith(currentParagraphIndex: state.currentParagraphIndex - 1));
      if (state.isPlaying) _speakCurrentParagraph();
    }
  }

  void nextParagraph(int totalParagraphs) {
    if (state.currentParagraphIndex < totalParagraphs - 1) {
      emit(state.copyWith(currentParagraphIndex: state.currentParagraphIndex + 1));
      if (state.isPlaying) _speakCurrentParagraph();
    }
  }

  @override
  Future<void> close() async {
    _flutterTts.setCompletionHandler(() {});
    try {
      await _flutterTts.stop();
    } catch (e) {
      developer.log('TTS stop failed on close', name: 'tts', error: e);
    }
    return super.close();
  }
}