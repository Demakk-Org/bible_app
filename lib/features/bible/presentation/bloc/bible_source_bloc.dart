import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/features/bible/domain/repository/bible_repository.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_source_state.dart';

class BibleSourceBloc extends Cubit<BibleSourceState> {
  BibleSourceBloc(this._bibleRepository)
    : super(const BibleSourceState(bibleSources: []));
  final BibleRepository _bibleRepository;

  Future<void> getBibleSources() async {
    emit(state.copyWith(status: BibleStatus.saving));
    final result = await _bibleRepository.getBibleSources();

    result.fold(
      (failure) {
        emit(state.copyWith(status: BibleStatus.error, error: failure.message));
      },
      (bibleSources) {
        emit(
          state.copyWith(
            status: BibleStatus.success,
            bibleSources: bibleSources,
          ),
        );
      },
    );
  }
}
