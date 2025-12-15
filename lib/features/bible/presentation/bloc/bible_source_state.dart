import 'package:equatable/equatable.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/bible/data/model/bible_source.dart';

class BibleSourceState extends Equatable {
  const BibleSourceState({
    required this.bibleSources,
    this.status = BibleStatus.initial,
    this.error = '',
  });

  final BibleStatus status;
  final String error;
  final List<BibleSource> bibleSources;

  BibleSourceState copyWith({
    BibleStatus? status,
    String? error,
    List<BibleSource>? bibleSources,
  }) {
    return BibleSourceState(
      status: status ?? this.status,
      error: error ?? this.error,
      bibleSources: bibleSources ?? this.bibleSources,
    );
  }

  @override
  List<Object?> get props => [status, error, bibleSources];
}
