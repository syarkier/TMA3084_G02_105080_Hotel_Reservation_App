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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Room')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // Animation 2: the page content fades and slides up when it opens
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 40 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Change 3: booking summary card
              Card(
                color: colors.primaryContainer,
                child: ListTile(
                  leading: Icon(
                    Icons.event_available,
                    color: colors.onPrimaryContainer,
                  ),
                  title: Text('Check-in ${widget.checkIn}'),
                  subtitle: Text('${widget.guests} guests'),
                ),
              ),
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
                      // Change 3: icon in a circle and the price under the name
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colors.secondaryContainer,
                          child: Icon(
                            room.icon,
                            color: colors.onSecondaryContainer,
                          ),
                        ),
                        title: Text(room.name),
                        subtitle: Text('RM ${room.price} / night'),
                      );
                    },
                    body: ListTile(title: Text(room.description)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
