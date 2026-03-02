import 'dart:typed_data';

class Contact {
  // Name
  final String name;

  // Contact avatar/thumbnail
  final Uint8List avatar;

  // class constructor
  Contact({
    required this.name,
    required this.avatar,
  });
}
