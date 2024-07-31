import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vania_music/core/utils/resources/route.dart';
import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';
import 'package:vania_music/features/music_album/presentation/bloc/music_album/music_album_bloc.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  _goToMuiscScreen(String link) {
    widget.navigatorKey.currentState!.pushNamed(Routes.music, arguments: link);
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Vania Music 🎧",
              style: GoogleFonts.pacifico(),
            ),
          ),
          BlocBuilder<MusicAlbumBloc, MusicAlbumState>(
            builder: (context, state) {
              if (state is MusicAlbumCompletedState) {
                return Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  height: MediaQuery.sizeOf(context).height * .9,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .9,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, i) {
                      return MusicAlbumWidget(
                        data: state.musicAlbums![i],
                        onTap: _goToMuiscScreen,
                      );
                    },
                    itemCount: state.musicAlbums?.length ?? 0,
                  ),
                );
              } else if (state is MusicAlbumErrorState) {
                return Positioned.fill(
                  child: Center(
                    child: Text(state.message ?? "Somthing went wrong..."),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          Positioned.fill(
            child: Visibility(
              visible: context.watch<MusicAlbumBloc>().state
                  is MusicAlbumLoadingState,
              child: ColoredBox(
                color: Colors.grey.shade500.withOpacity(.5),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
        ],
    
    );
  }
}

class MusicAlbumWidget extends StatelessWidget {
  const MusicAlbumWidget({
    super.key,
    required this.data,
    required this.onTap,
  });
  final MusicAlbumEntity data;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(data.link!),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.background,
                  image: data.img != null
                      ? DecorationImage(
                          image: NetworkImage(data.img!),
                          fit: BoxFit.fill,
                        )
                      : null),
              child: data.img != null
                  ? null
                  : FittedBox(
                      child: Text(
                        data.name!.split('Music')[0].toUpperCase(),
                        style: GoogleFonts.afacad(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "${data.name}",
          style: GoogleFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
