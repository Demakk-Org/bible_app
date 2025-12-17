import 'package:bible_app/common/utils/share.dart';
import 'package:bible_app/common/widgets/contained_icon_button.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/ui/bible/bible_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedVerseControlBar extends StatelessWidget {
  const SelectedVerseControlBar({
    required this.widget,
    required GlobalKey<State<StatefulWidget>> shareKey,
    super.key,
  }) : _shareKey = shareKey;

  final BibleSection widget;
  final GlobalKey<State<StatefulWidget>> _shareKey;

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();

    return Positioned(
      bottom: 16,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              spacing: 15,
              children: [
                KeyedSubtree(
                  key: widget.shareButtonKey,
                  child: ContainedIconButton(
                    action: () async {
                      await shareCapturedWidget(_shareKey);
                      widget.resetSelection();
                    },
                    icon: Icons.share_outlined,
                  ),
                ),
                KeyedSubtree(
                  key: widget.bookmarkButtonKey,
                  child: ContainedIconButton(
                    action: () async {
                      await bibleBloc.setVersesAsBookMark(
                        widget.selectedVerses,
                      );
                      widget.resetSelection();

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('The verse/s has/ve been bookmarked'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icons.bookmark_outline,
                  ),
                ),
                KeyedSubtree(
                  key: widget.copyButtonKey,
                  child: ContainedIconButton(
                    action: () {
                      final bookName = widget.selectedVerses.first.bookName;
                      final chapter = widget.selectedVerses.first.chapter;
                      final versesFrom = '$bookName $chapter';
                      final versesToCopy = widget.selectedVerses
                          .map((v) => '${v.verse} ${v.text}')
                          .join('\n');
                      Clipboard.setData(
                        ClipboardData(text: '$versesFrom: $versesToCopy'),
                      );
                    },
                    icon: Icons.copy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
