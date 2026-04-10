import 'package:flutter/material.dart';
import 'package:qflow/domain/core/failures.dart';

void showErrorSnackBar(BuildContext context, MainFailure failure) {
  final message = failure.map(
    clientFailure: (_) => "Something wrong with your network",
    authFailure: (_) => "Access token timed out",
    serverFailure: (_) => "Server is down",
    serverError: (e) => e.message ?? "Something Unexpected Happened",
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}
