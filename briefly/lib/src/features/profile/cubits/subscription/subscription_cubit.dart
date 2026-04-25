import 'package:flutter_bloc/flutter_bloc.dart';
import 'subscription_state.dart';
import '../../../../domain/models/plan_type.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionState());

  void selectPlan(PlanType plan) {
    emit(state.copyWith(selectedPlan: plan));
  }
}
