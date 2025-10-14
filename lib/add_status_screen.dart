import 'package:chat_box/services/my_service/status_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({super.key});

  @override
  State<AddStatusScreen> createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  final TextEditingController _controller = TextEditingController();
  final StatusService _service = StatusService();
  bool _isPosting = false;
  static int maxChars = 1000;

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please write something!!")));
      return;
    }
    if (text.length > maxChars) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Text too long")));
      return;
    }

    setState(() => _isPosting = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("Not logged in");
      await _service.uploadTextStatus(uid, text);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Status posted")));
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Upload text status error: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to post: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Text Status"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                autofocus: true,
                maxLength: maxChars,
                decoration: const InputDecoration(
                  hintText: "Write your status (text only)...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _isPosting
                ? Center(child: CircularProgressIndicator())
                : Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _post,
                        label: const Text("Post"),
                        icon: const Icon(Icons.send),
                      ),
                      const SizedBox(width: 12,),
                      Text('${_controller.text.length}/$maxChars'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
