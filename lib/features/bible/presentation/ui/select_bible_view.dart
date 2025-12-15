import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_app/common/utils/types.dart';
import 'package:bible_app/common/widgets/dropdown.dart';
import 'package:bible_app/core/theme/app_colors.dart';
import 'package:bible_app/features/bible/data/model/bible_page.dart';
import 'package:bible_app/features/bible/data/model/bible_source.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_source_bloc.dart';
import 'package:bible_app/features/bible/presentation/bloc/bible_source_state.dart';

class SelectBibleView extends StatefulWidget {
  const SelectBibleView({super.key});

  @override
  State<SelectBibleView> createState() => _SelectBibleViewState();
}

class _SelectBibleViewState extends State<SelectBibleView> {
  String selectedBibleSourceId = '';
  String selectedLanguage = 'All';

  void setSelectedBibleSourceId(String id) {
    setState(() {
      selectedBibleSourceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bibleSourceBloc = context.read<BibleSourceBloc>();
    return BlocBuilder<BibleSourceBloc, BibleSourceState>(
      builder: (context, state) {
        final bibleSources = state.bibleSources;

        final filteredBibles = selectedLanguage == 'All'
            ? bibleSources
            : bibleSources
                  .where(
                    (bible) => bible.language.toUpperCase() == selectedLanguage,
                  )
                  .toList();

        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await bibleSourceBloc.getBibleSources();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 18,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: AppColors.baseWhite,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.language),
                            Text(
                              'Language',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                height: 22 / 12,
                                color: AppColors.baseBlack,
                              ),
                            ),
                          ],
                        ),
                        DropDown(
                          value: selectedLanguage,
                          items: ['All', ..._getLanguageList(bibleSources)],
                          onChanged: (value) {
                            setState(() {
                              selectedLanguage = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.baseWhite,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        separatorBuilder: (context, index) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(color: AppColors.primary, height: 1),
                        ),
                        itemCount: filteredBibles.length,
                        itemBuilder: (context, index) => BibleSourceItem(
                          source: filteredBibles[index],
                          selectedBibleSourceId: selectedBibleSourceId,
                          setSelectedBibleSourceId: setSelectedBibleSourceId,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<String> _getLanguageList(List<BibleSource> bibles) {
    final languages = Set<String>.from(
      bibles.map((bible) => bible.language.toUpperCase()),
    );
    return languages.toList();
  }
}

class BibleSourceItem extends StatelessWidget {
  const BibleSourceItem({
    required this.source,
    required this.setSelectedBibleSourceId,
    required this.selectedBibleSourceId,
    super.key,
  });

  final BibleSource source;
  final void Function(String) setSelectedBibleSourceId;
  final String selectedBibleSourceId;

  @override
  Widget build(BuildContext context) {
    final bibleBloc = context.read<BibleBloc>();
    final bibleSourceBloc = context.read<BibleSourceBloc>();
    final status = bibleBloc.state.status;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          if (source.isDownloaded) {
            await bibleBloc.setCurrentBible(source.id);
            final firstVerse = bibleBloc.state.currentBible?.verses.first;
            bibleBloc
              ..changeChapter(
                BiblePage(
                  book: firstVerse!.book,
                  chapter: 1,
                  scrollToVerse: false,
                ),
              )
              ..closeBibleSelectView();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  _sourceShortName(source.shortName),
                  _sourceFullName(source.name),
                ],
              ),
              downloadButton(
                source.isDownloaded,
                selectedBibleSourceId == source.id
                    ? status
                    : BibleStatus.initial,
                () async {
                  setSelectedBibleSourceId(source.id);
                  await bibleBloc.downloadBible(source.id);
                  await bibleSourceBloc.getBibleSources();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _sourceShortName(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 16,
        height: 22 / 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColors.baseBlack,
      ),
    );
  }

  Text _sourceFullName(String fullName) {
    return Text(
      fullName,
      style: const TextStyle(
        fontSize: 14,
        height: 22 / 14,
        fontFamily: 'Poppins',
        color: AppColors.baseBlack,
      ),
    );
  }

  Widget downloadButton(
    bool isDownloaded,
    BibleStatus downloadStatus,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: isDownloaded
            ? const Icon(Icons.task_outlined, size: 24)
            : downloadStatus == BibleStatus.saving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              )
            : const Icon(Icons.download_outlined, size: 24),
      ),
    );
  }
}
