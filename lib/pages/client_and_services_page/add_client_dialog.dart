import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/clients.dart';

class AddClientDialog extends StatefulWidget {
  const AddClientDialog({
    super.key,
  });

  @override
  State<AddClientDialog> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<AddClientDialog> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  bool isNameError = false;
  bool isPhoneError = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(26))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Добавить клиента',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 16,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      isNameError = true;
                    });
                  } else if (isNameError) {
                    setState(() {
                      isNameError = false;
                    });
                  }
                },
                cursorWidth: 1,
                cursorColor: Colors.black,
                maxLength: 30,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: !isNameError ? Colors.black : Colors.red,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                  fillColor: !isNameError ? Colors.blue.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  labelText: '*Имя клиента',
                  filled: true,
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                controller: nameController,
                keyboardType: TextInputType.name,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      isPhoneError = true;
                    });
                  } else if (isPhoneError) {
                    setState(() {
                      isPhoneError = false;
                    });
                  }
                },
                cursorWidth: 1,
                cursorColor: Colors.black,
                maxLength: 30,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: !isPhoneError ? Colors.black : Colors.red,
                    fontSize: 14,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                  fillColor: !isPhoneError ? Colors.blue.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  labelText: '*Номер клиента',
                  filled: true,
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TextField(
                cursorWidth: 1,
                cursorColor: Colors.black,
                maxLength: 30,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                  fillColor: Colors.blue.withOpacity(0.2),
                  labelText: 'Заметка',
                  filled: true,
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                controller: noteController,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: context.pop, child: const Text('Отмена')),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        // ButtonStyle(
                        //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        //    ),
                        onPressed: isNameError || isPhoneError
                            ? null
                            : () {
                                if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                                  setState(() {
                                    isNameError = nameController.text.trim().isEmpty;
                                    isPhoneError = phoneController.text.trim().isEmpty;
                                  });
                                  return;
                                }
                                ref.read(clientsProvider.notifier).add(
                                      nameController.text,
                                      phoneController.text,
                                      noteController.text,
                                    );
                                context.pop();
                              },
                        child: const Text(
                          'Добавить',
                          style: TextStyle(color: Colors.white),
                        ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
