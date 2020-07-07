// //Categorias
//         Container(
//           //color: Colors.grey,
//           height: 120,
//           child: FutureBuilder<QuerySnapshot>(
//             future: Firestore.instance
//                 .collection('produtos')
//                 //.orderBy("pos", descending: false)
//                 //.limit(6)
//                 .getDocuments(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: CupertinoActivityIndicator(),
//                 );
//               } else {
//                 return ListView(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   physics: BouncingScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   children: snapshot.data.documents.map((doc) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Column(
//                         children: <Widget>[
//                           Material(
//                             elevation: 4,
//                             shadowColor: CupertinoColors.systemGrey6,
//                             borderRadius: BorderRadius.circular(8),
//                             child: Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Container(
//                             width: 80,
//                             child: Text(
//                               doc['titulo'],
//                               textAlign: TextAlign.center,
//                               style: fontBold14DarkSpace,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 );
//               }
//             },
//           ),
//         ),
