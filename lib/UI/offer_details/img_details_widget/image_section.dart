import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    Key? key,
    required this.offerImages,
  }) : super(key: key);

  final List<String> offerImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      child: ScrollSnapList(
        itemSize: MediaQuery.of(context).size.height / 3,
        dynamicItemSize: true,
        itemBuilder: (ctx, index) => Stack(
          children: [
            GestureDetector(
              onTap: (){
                NamedNavigatorImpl().push(NamedRoutes.IMAGE_SCREEN, arguments: {
                  'heroTag': 'image$index',
                  'imageUrl': offerImages[index],
                });
              },
              child: Hero(
                tag: 'image$index',
                child: Image.network(
                    offerImages[index],
                    width: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if(offerImages.length > 1)
              Positioned(
                bottom: 0,
                right: 8,
                child: Chip(
                  backgroundColor: MyColors.lightGrey,
                  label: Text(
                    '${index+1} / ${offerImages.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: MyColors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onItemFocus: (int) {},
        itemCount: offerImages.length,
      ),
    );
    // return Container(
    //   child: Stack(
    //     clipBehavior: Clip.none,
    //     alignment: Alignment.center,
    //     children: [
    //       Container(
    //         width: double.infinity,
    //         height: 160,
    //         decoration: BoxDecoration(
    //           image: DecorationImage(
    //             image: NetworkImage(productImage),
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       Container(
    //         margin: const EdgeInsets.symmetric(horizontal: 10),
    //         height: 180,
    //         width: double.infinity,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(10),
    //           child: Image(
    //             image: NetworkImage(userImage),
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         bottom: -26,
    //         right: 0,
    //         child: PopupMenuButton(
    //           icon: Icon(
    //             Icons.more_vert,
    //             color: MyColors.secondaryColor,
    //           ),
    //           offset: Offset(-10, 40),
    //           padding: const EdgeInsets.all(0),
    //           shape: OutlineInputBorder(
    //             borderSide: BorderSide(
    //               color: MyColors.primaryColor,
    //             ),
    //             borderRadius: BorderRadius.circular(25.0),
    //           ),
    //           itemBuilder: (ctx) {
    //             return [
    //               PopupMenuItem(
    //                 height: 4,
    //                 onTap: () {
    //                   print('Share');
    //                 },
    //                 child: Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Icon(Icons.share),
    //                     const SizedBox(width: 10),
    //                     Text('Share'),
    //                   ],
    //                 ),
    //               ),
    //               PopupMenuItem(
    //                 height: 4,
    //                 onTap: () {
    //                   print('copy link');
    //                 },
    //                 child: Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     RotatedBox(
    //                       quarterTurns: 5,
    //                       child: Icon(Icons.link_outlined),
    //                     ),
    //                     const SizedBox(width: 10),
    //                     Text('Copy Link'),
    //                   ],
    //                 ),
    //               ),
    //               PopupMenuItem(
    //                 height: 4,
    //                 onTap: () {
    //                   print('Report');
    //                 },
    //                 child: Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Icon(Icons.bug_report_rounded),
    //                     const SizedBox(width: 10),
    //                     Text('Report'),
    //                   ],
    //                 ),
    //               ),
    //             ];
    //           },
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
