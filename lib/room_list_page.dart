import 'package:flutter/material.dart';

import 'room_type.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({
    super.key,
    required this.preferred,
    required this.guests,
    required this.checkIn,
  });

  final RoomPreference preferred;
  final int guests;
  final String checkIn;

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  late final List<RoomType> _rooms;

  @override
  void initState() {
    super.initState();
    _rooms = buildRooms(widget.preferred);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Room')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Check-in ${widget.checkIn}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('${widget.guests} guests'),
            const SizedBox(height: 16),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _rooms[index].isExpanded = isExpanded;
                });
              },
              children: _rooms.map((room) {
                return ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: room.isExpanded,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      leading: Icon(room.icon),
                      title: Text(room.name),
                    );
                  },
                  body: ListTile(title: Text(room.description)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
