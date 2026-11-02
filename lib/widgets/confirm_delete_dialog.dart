import 'package:flutter/material.dart';

Future<bool> showDeleteConfirmation({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFD94C4C),
          size: 34,
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF25372B),
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Colors.grey.shade600,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF536357),
              side: const BorderSide(color: Color(0xFFDCE5DE)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD94C4C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Ya, Hapus'),
          ),
        ],
      );
    },
  );

  return result == true;
}
