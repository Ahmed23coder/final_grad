import 'package:equatable/equatable.dart';

enum FeedbackStatus { idle, submitting, success }

class FaqItem extends Equatable {
  final String id;
  final String category;
  final String question;
  final String answer;

  const FaqItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  @override
  List<Object?> get props => [id, category, question, answer];
}

class HelpSupportState extends Equatable {
  final String searchQuery;
  final int feedbackRating;
  final String feedbackText;
  final FeedbackStatus feedbackStatus;
  final Set<String> expandedFaqIds;
  final List<FaqItem> allFaqs;

  HelpSupportState({
    this.searchQuery = '',
    this.feedbackRating = 0,
    this.feedbackText = '',
    this.feedbackStatus = FeedbackStatus.idle,
    this.expandedFaqIds = const {},
    List<FaqItem>? allFaqs,
  }) : allFaqs = allFaqs ?? _defaultFaqs();

  bool get isSearchMode => searchQuery.isNotEmpty;

  List<FaqItem> get filteredFaqs {
    if (searchQuery.isEmpty) return allFaqs;
    final query = searchQuery.toLowerCase();
    return allFaqs.where((faq) {
      return faq.question.toLowerCase().contains(query) ||
             faq.answer.toLowerCase().contains(query);
    }).toList();
  }

  Map<String, List<FaqItem>> get groupFaqsByCategory {
    final faqs = filteredFaqs;
    final map = <String, List<FaqItem>>{};
    for (var faq in faqs) {
      map.putIfAbsent(faq.category, () => []).add(faq);
    }
    return map;
  }

  HelpSupportState copyWith({
    String? searchQuery,
    int? feedbackRating,
    String? feedbackText,
    FeedbackStatus? feedbackStatus,
    Set<String>? expandedFaqIds,
    List<FaqItem>? allFaqs,
  }) {
    return HelpSupportState(
      searchQuery: searchQuery ?? this.searchQuery,
      feedbackRating: feedbackRating ?? this.feedbackRating,
      feedbackText: feedbackText ?? this.feedbackText,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      expandedFaqIds: expandedFaqIds ?? this.expandedFaqIds,
      allFaqs: allFaqs ?? this.allFaqs,
    );
  }

  @override
  List<Object?> get props => [
        searchQuery,
        feedbackRating,
        feedbackText,
        feedbackStatus,
        expandedFaqIds,
        allFaqs,
      ];

  static List<FaqItem> _defaultFaqs() {
    return [
      // Getting Started
      const FaqItem(id: 'gs1', category: 'Getting Started', question: 'How do I personalize my news feed?', answer: 'You can personalize your news feed by navigating to the Interests screen in your profile and selecting the topics that matter most to you.'),
      const FaqItem(id: 'gs2', category: 'Getting Started', question: 'What is Rasseny Intelligence?', answer: 'Rasseny Intelligence is an AI-powered news companion that curates and summarizes articles for you.'),
      const FaqItem(id: 'gs3', category: 'Getting Started', question: 'How do I turn on notifications?', answer: 'Go to Settings > Notifications to enable or disable alerts for breaking news and updates.'),
      // Fake Detection
      const FaqItem(id: 'fd1', category: 'Fake Detection', question: 'How does the Fact Checker work?', answer: 'The Fact Checker cross-references statements with trusted databases and provides a reliability score.'),
      const FaqItem(id: 'fd2', category: 'Fake Detection', question: 'Can I report a potentially fake article?', answer: 'Yes, you can tap the "Report" button on any article to flag it for our moderation team.'),
      // Account & Billing
      const FaqItem(id: 'ab1', category: 'Account & Billing', question: 'How do I change my subscription?', answer: 'Go to Profile > Subscription to manage or upgrade your current plan.'),
      const FaqItem(id: 'ab2', category: 'Account & Billing', question: 'How to update my payment method?', answer: 'In the Subscription section, tap on "Payment Methods" and add or remove your cards.'),
      const FaqItem(id: 'ab3', category: 'Account & Billing', question: 'Where can I find my invoice?', answer: 'Invoices are emailed to you monthly, and you can also download them under Billing History.'),
      // Content & Feed
      const FaqItem(id: 'cf1', category: 'Content & Feed', question: 'How to save an article for later?', answer: 'Tap the bookmark icon on any article to save it to your Vault / Saved items.'),
      const FaqItem(id: 'cf2', category: 'Content & Feed', question: 'Can I share articles with friends?', answer: 'Absolutely! Use the share icon on an article to send it via messaging apps or social media.'),
    ];
  }
}
