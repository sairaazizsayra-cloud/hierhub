import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/prsentation/bookmark/provider/bookmark_jobs_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Header extends StatelessWidget {
  final int jobId;
  final String jobTitle;
  final String companyName;

  const Header({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
  });

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            ),
            Row(
              children: [
                Consumer<BookMarkJobProvider>(
                  builder: (context, bookmarkProvider, _) {
                    final isBookmarked = bookmarkProvider.jobs.contains(jobId);
                    return IconButton(
                      tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final wasBookmarked = isBookmarked;
                        await bookmarkProvider.toggleBookmark(jobId);
                        if (!context.mounted) return;
                        _snack(
                          context,
                          wasBookmarked
                              ? 'Removed from bookmarks'
                              : 'Saved to bookmarks',
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  tooltip: 'Share',
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () async {
                    try {
                      await Share.share(
                        'Check out $jobTitle at $companyName on HireHub!',
                        subject: jobTitle,
                      );
                    } catch (_) {
                      if (!context.mounted) return;
                      _snack(context, 'Share: $jobTitle at $companyName');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
