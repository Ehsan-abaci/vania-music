import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vania_music/core/utils/resources/color_manager.dart';

class PlayShuffleWidget extends StatelessWidget {
  const PlayShuffleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorManager.bg,
      surfaceTintColor: ColorManager.bg,
      automaticallyImplyLeading: false,
      pinned: true,
      primary: false,
      toolbarHeight: 0,
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_outline_rounded),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Play",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size.fromHeight(50),
                      backgroundColor: Colors.white70,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shuffle),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Shuffle",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
