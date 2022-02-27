import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(BuildContext context) {
  const String _dialogTittle = 'Word Short!';
  const String _dialogContent =
      'The entered task is shorter than 3 letters. Please write longer.';
  const String _alertClose = 'Close';

  const Color _alertDialogColor = Color(0xFF4044cc);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _alertDialogColor,
          title: const Text(_dialogTittle),
          content: const Text(_dialogContent),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(_alertClose))
          ],
        );
      });
}
