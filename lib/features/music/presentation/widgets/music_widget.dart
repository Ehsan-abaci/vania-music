import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vania_music/features/music/presentation/bloc/music/music_bloc.dart';
import 'package:vania_music/features/music_album/presentation/bloc/music_album/music_album_bloc.dart';

class MusicWidget extends StatelessWidget {
  const MusicWidget({super.key, required this.link});
  final String link;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          var musicAlbum =
              (context.read<MusicAlbumBloc>().state as MusicAlbumCompletedState)
                  .musicAlbums
                  ?.firstWhere((e) => e.link == link);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 120,
                  width: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(.8),
                          blurRadius: 20,
                          offset: const Offset(0, 8)),
                    ],
                  ),
                  child: FittedBox(
                    child: Text(
                      "${musicAlbum?.name?.split(" ")[0].toUpperCase()}",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.afacad(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          musicAlbum!.name!,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (state is MusicCompletedState)
                        Text(
                          "${state.musics.length} Musics",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Icon(
                              color: Colors.grey,
                              Icons.queue_music,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Icon(
                              color: Colors.grey,
                              Icons.download_for_offline_outlined,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            icon: Icon(
                              color: Colors.grey,
                              Icons.more_horiz_rounded,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
