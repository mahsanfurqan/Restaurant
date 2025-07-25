import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/result_state.freezed.dart';

@Freezed()
sealed class ResultState<T> with _$ResultState<T> {
  const factory ResultState.initial() = ResultInitial;
  const factory ResultState.loading() = ResultLoading;
  const factory ResultState.success(T data) = ResultSuccess<T>;
  const factory ResultState.failed([String? message]) = ResultFailed;
}
