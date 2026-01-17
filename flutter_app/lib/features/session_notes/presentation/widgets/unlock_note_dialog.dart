import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

class UnlockNoteDialog extends StatefulWidget {
  const UnlockNoteDialog({super.key});

  @override
  State<UnlockNoteDialog> createState() => _UnlockNoteDialogState();
}

class _UnlockNoteDialogState extends State<UnlockNoteDialog> {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.sessionNote_unlock),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _reasonController,
          decoration: InputDecoration(
            labelText: l10n.sessionNote_unlockReason,
            hintText: l10n.sessionNote_unlockReasonHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.form_error_required;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.sessionNote_cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_reasonController.text.trim());
            }
          },
          child: Text(l10n.sessionNote_unlockConfirm),
        ),
      ],
    );
  }
}
