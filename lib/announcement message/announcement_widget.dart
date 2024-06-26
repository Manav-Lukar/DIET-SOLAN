import 'package:flutter/material.dart';

class AnnouncementWidget extends StatelessWidget {
  final String? message;
  final Function()? onClose;

  const AnnouncementWidget({Key? key, this.message, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message != null
        ? Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.announcement, color: Colors.black87),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
