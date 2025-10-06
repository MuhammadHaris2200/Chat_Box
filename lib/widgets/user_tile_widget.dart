// class UserTileWidget extends StatelessWidget {
//   final String name;
//   final String? photoUrl;
//   final String lastMessage;
//   final VoidCallback onTap;

//   const UserTileWidget({
//     super.key,
//     required this.name,
//     this.photoUrl,
//     this.lastMessage = '',
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return  ListTile(
//       leading: CircleAvatar(
//         backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
//         child: photoUrl == null ? Icon(AppIcons.cupertinoPersonIcon) : null,
//       ),

//       title: Text(name,style: TextStyle(fontWeight: FontWeight.w500),),
//       subtitle: Text(lastMessage,maxLines: 1,overflow: TextOverflow.ellipsis,),
//       onTap: onTap,
//     );
//   }
// }
