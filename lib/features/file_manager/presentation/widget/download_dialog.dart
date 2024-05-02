import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vania_music/features/file_manager/presentation/value_notifier/download_file.dart';
import 'package:vania_music/locator.dart';

class DownloadDialog extends StatelessWidget {
  const DownloadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ValueListenableBuilder(
        valueListenable: di<DownloadFile>().downloadProgressNotifier,
        builder: (context, progressVal, child) => Container(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 45,
                    child: ValueListenableBuilder(
                      valueListenable: di<DownloadFile>().downloadStatus,
                      builder: (context, status, child) {
                        late String text;
                        if (status == DownloadStatus.downloading)
                          text = "Downloading...";
                        if (status == DownloadStatus.downloaded) {
                          text = "Saved";
                          Future.delayed(const Duration(seconds: 1)).then(
                            (_) => Navigator.pop(context),
                          );
                        }
                        return Text(
                          text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        );
                      },
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(15),
                  value: progressVal / 100,
                ),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text("%$progressVal"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
